//
//  LLParser.swift
//  Localevel
//
//  Created by Neil Ballard on 7/26/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class LRParser: NSObject
{
    public static func parseAuth(_ json: JSON, completion: @escaping (_ error: Error?) -> Void)
    {
        
        print(json)

        if let token = json["token"].string
        {
            let error = NSError(domain:"", code:500, userInfo:[ NSLocalizedDescriptionKey: "Server Error"])
            
            let user = json["user"]
            guard let email = user["email"].string, let first = user["first_name"].string else
            {
                completion(error)
                return
            }

            let profile = json["profile"]
            
            guard let userID = profile["user"].int, let profileID = profile["id"].int, let number = profile["number"].string else
            {
                completion(error)
                return
            }
            
            Defaults.saveUser(user: userID, id: profileID, email: email, first: first, number: number)
            Defaults.setLoginStatus(status: true)
            AuthorizationKeychain.shared.saveAuthCode(token)
            completion(nil)
        }
        else
        {
            let error = NSError(domain:"", code:401, userInfo:[ NSLocalizedDescriptionKey: "Login Error. Try again."])
            completion(error)
        }
    }
    
    public static func getCity(_ restaurant : Restaurant) -> String
    {
        var arr = restaurant.location.components(separatedBy: ",")
        
        if arr.count > 1
        {
            return arr[1]
        }
        
        return restaurant.location
    }
}
