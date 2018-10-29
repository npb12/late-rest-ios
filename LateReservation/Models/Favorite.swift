//
//  Favorite.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/7/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class Favorite : Restaurant
{
    
    public struct JsonKeys
    {
        static let favId = "id"
        static let resOject = "restaurant_object"
    }
    
    var favoriteId : Int = 0
    
    public static func frmJson(_ json: JSON) -> [Favorite]
    {
        var favorites = [Favorite]()
        
        for (_, object) in json
        {
            let resObject = object[JsonKeys.resOject]
            if let id = object[JsonKeys.favId].int
            {
                let favorite = parseFavorite(resObject)
                favorite.favoriteId = id
                favorites.append(favorite)
            }
        }
        
        return favorites
    }
    
    public static func parseFavorite(_ object: JSON) -> Favorite
    {
        let restaurant = Favorite()
        
        if let id = object[JsonKeys.id].int
        {
            restaurant.id = id
        }
        
        if let createdBy = object[JsonKeys.createdBy].int
        {
            restaurant.createdBy = createdBy
        }
        
        if let longitude = object[JsonKeys.lon].double
        {
            restaurant.lon = longitude
        }
        
        if let latitude = object[JsonKeys.lat].double
        {
            restaurant.lat = latitude
        }
        
        restaurant.photo = object[JsonKeys.photo].stringValue
        restaurant.restaurantName = object[JsonKeys.name].stringValue
        restaurant.location = object[JsonKeys.location].stringValue
        restaurant.website = object[JsonKeys.website].stringValue
        restaurant.description = object[JsonKeys.description].stringValue
        
        return restaurant
    }
}
