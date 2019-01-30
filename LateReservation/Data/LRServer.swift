//
//  LRServer.swift
//  Localevel
//
//  Created by Neil Ballard on 7/25/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation

class LRServer : NSObject
{
    public static let shared = LRServer()
    private let baseURL = "https://late-reservation.herokuapp.com/api/"
    
    private enum Endpoint: String
    {
        case register = "register/"
        case auth = "token-auth/"
        case nearby = "tables/?lat=%f&lon=%f"
        case favorites = "favourites/"
        case deleteFavorite = "favourites/%d/"
        case myReservations = "my-reservations/"
        case reserve = "reserve/"
        case isAvailable = "is-available/%d/"
        case tables = "tables/%d/"
        case changePassword = "change-password/"
        case deviceToken = "device-token/"
        case redeem = "redeem/"
    }
    
    private func formattedEndpoint(_ endpoint: Endpoint) -> String
    {
        return baseURL + endpoint.rawValue
    }
    
    private func formattedEndpoint(_ endpoint: String) -> String
    {
        return baseURL + endpoint
    }
    
    private func apiHeader() -> HTTPHeaders
    {
        guard let token = AuthorizationKeychain.shared.getAuthCode() else
        {
            NotificationCenter.default.post(name: Notification.Name.authDidExpire, object: nil)
            return HTTPHeaders()
        }
        
        return [ "Authorization" :  "Token " + token ]
    }
    
    public func register(_ info: RegistrationInfo, completion: @escaping (_ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.register)
        let parameters: Parameters =
            [ "email" : info.email.lowercased(),
              "username" : info.email.lowercased(),
              "first_name" : info.first,
              "number" : info.phone,
              "password" : info.password,
              "owner" : ""]

        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    LRParser.parseAuth(json, completion: completion)
                case .failure(let error):
                    let json = JSON(error)
                    completion(error)
                }
            }
        }
    }
    
    public func authorize(_ info: LoginInfo, completion: @escaping (_ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.auth)
        let parameters: Parameters =
            [ "username" : info.email.lowercased(),
              "password" : info.password ]
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    LRParser.parseAuth(json, completion: completion)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    public func updateDeviceToken(_ token: String)
    {
        let urlStr = formattedEndpoint(Endpoint.deviceToken)
        let parameters: Parameters =
            [ "token" : token ]
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                case .failure(let error):
                    let json = JSON(error)
                    print(json)
                }
            }
        }
    }
    
    public func changePassword(_ password: String, completion: @escaping (_ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.changePassword)
        let parameters: Parameters =
            [ "password" : password ]
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    completion(nil)
                case .failure(let error):
                    completion(error)
                }
            }
        }
    }
    
    public func getNearbyRestaurants(_ location: CLLocation, _ all : Bool, completion: @escaping (_ restaurants: [Restaurant]?, _ error: Error?) -> Void)
    {
        let lat = location.coordinate.latitude as Double
        let lon = location.coordinate.longitude as Double
        let locationEndpoint = String(format:Endpoint.nearby.rawValue, lat, lon)
        let urlStr = formattedEndpoint(locationEndpoint)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let restaurants = Restaurant.fromJson(json, all)
                    completion(restaurants, nil)
                 //   completion(startups, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func getFavorites(completion: @escaping (_ favorites: [Favorite]?, _ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.favorites)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let favorites = Favorite.frmJson(json)
                    Favorites.syncFavorites(favorites)
                    completion(favorites, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func addFavorite(_ restaurant: Restaurant, completion: @escaping () -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.favorites)
        let parameters: Parameters =
            [ "restaurant" : restaurant.id ]
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let favorite = Favorite.parseFavorite(json)
                    Favorites.addFavorite(favorite)
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    public func deleteFavorite(_ id: Int, completion: @escaping () -> Void)
    {
        let deleteEndpoint = String(format:Endpoint.deleteFavorite.rawValue, id)
        let urlStr = formattedEndpoint(deleteEndpoint)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    Favorites.deleteFavorite(id)
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    /*
    ///
    /// All Things reservations
    ///
    */
    
    public func redeemed(_ tableId: Int, completion: @escaping () -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.redeem)
        let parameters: Parameters =
            [ "table" : tableId ]
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in

                completion()
            }
        }
    }
    
    public func reserve(_ tableID: Int, _ party: Int, completion: @escaping (_ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.reserve)
        let parameters: Parameters =
            [ "tableID" : tableID,
              "party" : party]
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(nil)
                case .failure(let error):
                    let json = JSON(error)
                    completion(error)
                }
            }
        }
    }
    
    public func isAvailable(_ tableID: Int, completion: @escaping (_ available: Bool) -> Void)
    {
        let availableEndpoint = String(format:Endpoint.isAvailable.rawValue, tableID)
        let urlStr = formattedEndpoint(availableEndpoint)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if let available = json["message"].bool
                    {
                        completion(available)
                    }
                    else
                    {
                        completion(false)
                    }
                case .failure(let error):
                    completion(false)
                }
            }
        }
    }
    
    public func getMyReservations(completion: @escaping (_ reservations: [LateReservation]?, _ error: Error?) -> Void)
    {
        let urlStr = formattedEndpoint(Endpoint.myReservations)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    let reservations = MyReservations.fromJson(json)
                    completion(reservations, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func getTables(_ restaurant: Restaurant, completion: @escaping () -> Void)
    {
        let availableEndpoint = String(format:Endpoint.tables.rawValue, restaurant.id)
        let urlStr = formattedEndpoint(availableEndpoint)
        let header = apiHeader()
        
        if let url = URL.init(string: urlStr)
        {
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).validate(contentType: ["application/json"]).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    LateReservation.parseReservations(restaurant, json)
                    completion()
                case .failure(let error):
                    completion()
                }
            }
        }
    }
}
 
 
