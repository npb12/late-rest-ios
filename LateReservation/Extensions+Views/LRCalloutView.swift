//
//  LRCalloutView.swift
//  LateReservation
//
//  Created by Neil Ballard on 1/3/19.
//  Copyright © 2019 Neil Ballard. All rights reserved.
//

import UIKit
import CoreLocation

protocol RestaurantDetailMapViewDelegate: class {
    func detailsRequestedForRestaurant(restaurant: Restaurant)
}

class LRCalloutView: UIView {

    @IBOutlet var label: UILabel!
    
    weak var delegate: RestaurantDetailMapViewDelegate?
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        layer.borderColor = UIColor.header.cgColor
        layer.borderWidth = 1
    }
    
    func setRestaurant(_ rest : Restaurant)
    {
        if let lastLocation = Defaults.getLastLocation()
        {
            let restLocation = CLLocation(latitude: rest.lat, longitude: rest.lon)
            let distance = LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restLocation)
            label.text = String(format: "%.1f mi", distance)
        }
    }
}
