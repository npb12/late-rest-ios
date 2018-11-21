//
//  MyReservations.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/9/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class MyReservations : LateReservation
{
    public struct JsonKeys
    {
        static let tableJson = "table"
        static let restaurantJson = "rest"
    }
    
    public static func fromJson(_ json: JSON) -> [LateReservation]
    {
        var reservations = [LateReservation]()
        
        for (_, obj) in json
        {
            let tableData = obj[JsonKeys.tableJson]
            let restaurantData = obj[JsonKeys.restaurantJson]
            
            let restaurant = Restaurant.parseRestaurant(restaurantData)
            let table = parseReservation(restaurant, tableData)
            reservations.append(table)
        }

        return reservations
    }
}
