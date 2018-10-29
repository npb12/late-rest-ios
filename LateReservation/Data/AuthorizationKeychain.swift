//
//  AuthorizationKeychain.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/16/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class AuthorizationKeychain: NSObject
{
    private let key = "llAuthKey"
    public static let shared = AuthorizationKeychain()
    
    public func saveAuthCode(_ auth: String)
    {
        KeychainWrapper.standard.set(auth, forKey: key)
    }
    
    public func getAuthCode() -> String?
    {
        return KeychainWrapper.standard.string(forKey: key)
    }
    
    public func removeAuthCode()
    {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
}
