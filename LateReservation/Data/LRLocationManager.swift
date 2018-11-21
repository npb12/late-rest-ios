//
//  LLLocationManager.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

//possible errors
enum LLLocationManagerErrors: Int {
    case AuthorizationDenied
    case AuthorizationNotDetermined
    case InvalidLocation
}

class LRLocationManager: NSObject, CLLocationManagerDelegate {
    
    //location manager
    private var locationManager: CLLocationManager?
    
    //destroy the manager
    deinit {
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    typealias LocationClosure = ((_ location: CLLocation?, _ error: NSError?)->())
    private var didComplete: LocationClosure?
    
    //location manager returned, call didcomplete closure
    private func _didComplete(location: CLLocation?, error: NSError?) {
        locationManager?.stopUpdatingLocation()
        didComplete?(location, error)
        locationManager?.delegate = nil
        locationManager = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .authorizedWhenInUse:
            self.locationManager!.startUpdatingLocation()
        case .denied:
            _didComplete(location: nil, error: NSError(domain: self.classForCoder.description(),
                                                       code: LLLocationManagerErrors.AuthorizationDenied.rawValue,
                                                       userInfo: nil))
        default:
            break
        }
    }
    
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _didComplete(location: nil, error: error as NSError)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        _didComplete(location: location, error: nil)
    }
    
    //ask for location permissions, fetch 1 location, and return
    func fetchWithCompletion(completion: @escaping LocationClosure) {
        //store the completion closure
        didComplete = completion
        
        //fire the location manager
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        
        //check for description key and ask permissions
        if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil)
        {
            locationManager!.requestWhenInUseAuthorization()
        }
        else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil)
        {
            locationManager!.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS11 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }
        
    }
    
    static func fetchCityAndCountry(location: CLLocation, completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       error)
        }
    }
    
    static func distanceBetween(userLocation location1: CLLocation, restaurantLocation location2: CLLocation) -> Double
    {
        let distanceInMeters = location1.distance(from: location2)
        return distanceInMeters/1609.344
    }
}
