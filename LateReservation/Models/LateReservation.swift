//
//  LateReservation.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/23/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

import SwiftyJSON
import Alamofire


public class LateReservation
{
    public struct JsonKeys
    {
        static let jsonId = "tables"
        static let restaurantId = "restaurant"
        static let tableID = "id"
        static let party = "party"
        static let minParty = "minParty"
        static let time = "time"
        static let discount = "discount"
    }
    
    var restaurant : Restaurant? = nil
    var restaurantId : Int = 0
    var tableId : Int = 0
    var party : Int = 0
    var minParty : Int = 0
    var discount : Int = 0
    var reservationTime : Date? = nil

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
    
    public static func fromJson(_ restaurant: Restaurant, _ json: JSON) -> [LateReservation]
    {
        var reservations = [LateReservation]()
        
        print(json)
        
        for (_, object) in json
        {
            reservations.append(parseReservation(restaurant ,object))
        }
        
        return reservations
    }
    
    public static func parseReservation(_ restaurant: Restaurant, _ object: JSON) -> LateReservation
    {
      //  let object = json[JsonKeys.jsonId]
        print(object)
        
        let reservation = LateReservation()
        
        reservation.restaurant = restaurant
        
        if let id = object[JsonKeys.restaurantId].int
        {
            reservation.restaurantId = id
        }
        
        if let tableID = object[JsonKeys.tableID].int
        {
            reservation.tableId = tableID
        }
        
        if let party = object[JsonKeys.party].int
        {
            reservation.party = party
        }

        if let minParty = object[JsonKeys.minParty].int
        {
            reservation.minParty = minParty
        }
        
        if let discount = object[JsonKeys.discount].int
        {
            reservation.discount = discount
        }
        
        let dateStr = object[JsonKeys.time].stringValue
        //2018-10-02T22:57:49Z
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        reservation.reservationTime = dateFormatter.date(from: dateStr)
        
        return reservation
    }
    
    public static func parseReservations(_ restaurant: Restaurant, _ json: JSON)
    {
        let obj = json[JsonKeys.jsonId]
        
        for (_, object) in obj
        {
            let reservation = LateReservation()
            
            reservation.restaurant = restaurant
            
            if let id = object[JsonKeys.restaurantId].int
            {
                reservation.restaurantId = id
            }
            
            if let tableID = object[JsonKeys.tableID].int
            {
                reservation.tableId = tableID
            }
            
            if let party = object[JsonKeys.party].int
            {
                reservation.party = party
            }
            
            if let minParty = object[JsonKeys.minParty].int
            {
                reservation.minParty = minParty
            }
            
            if let discount = object[JsonKeys.discount].int
            {
                reservation.discount = discount
            }
            
            let dateStr = object[JsonKeys.time].stringValue
            //2018-10-02T22:57:49Z
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            reservation.reservationTime = dateFormatter.date(from: dateStr)
            restaurant.reservations.append(reservation)
        }
    }
}

/*
struct LateReservation
{
    let table : LateTable
    let reservationTime : String
    let expired :Bool
}

let reservations = [LateReservation(table: tableData[0], reservationTime: "6:45 pm", expired: false), LateReservation(table: tableData[1], reservationTime: "Yesterday", expired: true)] */
