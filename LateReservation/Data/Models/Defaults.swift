//
//  Defaults.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import CoreLocation

struct Defaults {
    
    static let (userKey, idKey, emailKey, firstKey, phoneKey) = ("user", "id", "email", "first", "number")
    static let userSessionKey = "com.save.usersession"
    static let userLoggedinKey = "userLogin"
    static let returningUserKey = "returningUserKey"
    static let userModeKey = "userMode"
    static let lastLocationKey = "lastLocation"
    static let usedDiscountBeforeKey = "DiscountKey"

    struct UserModel : Codable {
        var user: Int?
        var id: Int?
        var email : String?
        var first : String?
        var number : String?
    }
    
    
    static func isLoggedIn() -> Bool
    {
        return UserDefaults.standard.bool(forKey: userLoggedinKey)
    }
    
    static func returningUser() -> Bool
    {
        return UserDefaults.standard.bool(forKey: returningUserKey)
    }
    
    static func usedDiscountBefore() -> Bool
    {
        return UserDefaults.standard.bool(forKey: usedDiscountBeforeKey)
    }
    
    static func setusedDiscountBefore()
    {
        UserDefaults.standard.set(true, forKey: usedDiscountBeforeKey)
    }
    
    static func setReturningUser(status: Bool)
    {
        UserDefaults.standard.set(status, forKey: returningUserKey)
    }
    
    static func setLoginStatus(status: Bool)
    {
        UserDefaults.standard.set(status, forKey: userLoggedinKey)
    }
    
    static func getLastLocation() -> CLLocation?
    {
        if let locationDictionary = UserDefaults.standard.dictionary(forKey: lastLocationKey) as? Dictionary<String,NSNumber> {
            let locationLat = locationDictionary["lat"]!.doubleValue
            let locationLon = locationDictionary["lon"]!.doubleValue
            return CLLocation(latitude: locationLat, longitude: locationLon)
        }
        
        return nil
    }
    
    static func setLastLocation(location: CLLocation)
    {
        let dict = ["lat": location.coordinate.latitude, "lon": location.coordinate.longitude]
        UserDefaults.standard.set(dict, forKey: lastLocationKey)
    }
    
    static func saveUser(user: Int, id: Int, email: String, first: String, number: String)
    {
        let user = UserModel(user: user, id: id, email: email, first: first, number: number)
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userSessionKey)
        }
    }
    
    static func getUser() -> UserModel?
    {
        if let userData = UserDefaults.standard.data(forKey: userSessionKey),
            let user = try? JSONDecoder().decode(UserModel.self, from: userData) {
            return user
        }
        
        return nil
    }
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: userSessionKey)
    }
    
    static func clearUserMode(){
        UserDefaults.standard.removeObject(forKey: userModeKey)
    }
}
