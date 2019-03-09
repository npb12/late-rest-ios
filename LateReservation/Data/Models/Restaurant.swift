//
//  LateTable.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreLocation

public class Restaurant
{
    public struct JsonKeys
    {
        static let jsonId = "rest"
        static let jsonTablesId = "tables"
        static let id = "id"
        static let name  = "restaurant_name"
        static let description = "description"
        static let location = "location"
        static let createdBy = "created_by"
        static let website = "website"
        static let lat = "lat"
        static let lon = "lon"
        static let photo = "cover_photo"
    }
    
    var id : Int = 0
    var restaurantName : String = ""
    var createdBy : Int = 0
    var lat : Double = 0
    var lon : Double = 0
    var distance : Double = 0
    var website : String = ""
    var photo : String = ""
    var description : String = ""
    var location : String = ""
    var reservations = [LateReservation]()
    
    /*
    public static func toJson(_ startup: Startup) -> Parameters
    {
        return [ JsonKeys.startupName : startup.startupName, JsonKeys.pitch : startup.pitch,
                 JsonKeys.elevator : startup.elevator, JsonKeys.website : startup.website,
                 JsonKeys.imglink : startup.image, JsonKeys.minimumInvestment : startup.minInvestment,
                 JsonKeys.history : startup.history, JsonKeys.lengthWorked : startup.lengthWorked,
                 JsonKeys.farAlong : startup.farAlong, JsonKeys.competitors : startup.competitors,
                 JsonKeys.makeMoney : startup.makeMoney, JsonKeys.revenue : startup.revenue,
                 JsonKeys.understanding : startup.understanding, JsonKeys.whatsNew : startup.whatsNew]
    } */
    
    public static func fromJson(_ json: JSON, _ all : Bool) -> [Restaurant]
    {
        var restaurants = [Restaurant]()
        
        for (_, object) in json
        {
            let data = object[JsonKeys.jsonId]
            let restaurant = parseRestaurant(data)
            let tables = object[JsonKeys.jsonTablesId]
            restaurant.reservations = LateReservation.fromJson(restaurant, tables)
            
            if let lastLocation = Defaults.getLastLocation()
            {
                let restaurantLocation = CLLocation(latitude: restaurant.lat, longitude: restaurant.lon)
                restaurant.distance = LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation)
            }
            
            restaurants.append(restaurant)
            /*
            if all
            {
                restaurants.append(restaurant)
            }
            else if restaurant.reservations.count > 0
            {
                restaurants.append(restaurant)
            } */
        }
        
        restaurants = restaurants.sorted(by: { $1.distance > $0.distance })
        
        var i = 0
        for res in restaurants
        {
            if res.restaurantName == "Jersey Mike's"
            {
                let jmikes = res
                restaurants.remove(at: i)
                restaurants.append(jmikes)
            }
            i += 1
        }
        
        restaurants = restaurants.sorted(by: { $0.reservations.count > $1.reservations.count })
        return restaurants
    }
    
    public static func parseRestaurant(_ json: JSON) -> Restaurant
    {
        let restaurant = Restaurant()
        
        if let id = json[JsonKeys.id].int
        {
            restaurant.id = id
        }
        
        if let createdBy = json[JsonKeys.createdBy].int
        {
            restaurant.createdBy = createdBy
        }
        
        let longitude = json[JsonKeys.lon].stringValue
        let latitude = json[JsonKeys.lat].stringValue
        
        if !longitude.isEmpty
        {
            restaurant.lon = Double(longitude)!
        }
        
        if !latitude.isEmpty
        {
            restaurant.lat = Double(latitude)!
        }
        
        restaurant.photo = json[JsonKeys.photo].stringValue
        restaurant.restaurantName = json[JsonKeys.name].stringValue
        restaurant.location = json[JsonKeys.location].stringValue
        restaurant.website = json[JsonKeys.website].stringValue
        restaurant.description = json[JsonKeys.description].stringValue

        return restaurant
    }
}


/*
struct LateTable
{
    let name : String
    let discount : Int
    let img : UIImage
    let location : String
    let party : Int
    let time : String
    let lat : Double
    let lon : Double
}

let tableData = [LateTable(name: "Dijon's Chop House", discount: 15, img: #imageLiteral(resourceName: "dej_image"), location: "2.1 mi - Melbourne Beach", party: 2, time: "3 Tables Available Tonight", lat: 28.068464, lon: -80.563795), LateTable(name: "Enrique's Cuisine", discount: 15, img: #imageLiteral(resourceName: "res_image"), location: "3.5 mi - Melbourne Beach", party: 2, time: "6:15 PM", lat: 28.077699, lon: -80.599535), LateTable(name: "Dijon's Chop House", discount: 15, img: #imageLiteral(resourceName: "res_image"), location: "Melbourne Beach, FL", party: 2, time: "6:15 PM", lat: 28.068446, lon: -80.558721)] */
