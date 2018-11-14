//
//  Registration.swift
//  Localevel
//
//  Created by Neil Ballard on 7/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation

struct LoginInfo
{
    let email : String
    let password : String
}

class RegistrationInfo
{
    var email : String = ""
    var password : String = ""
    var confirm : String = ""
    var first : String = ""
    var phone : String = ""
}

class Credentials
{
    static let passLength = 8
    
    enum infoErr: String
    {
        case invalidEmail = "Email entered is not valid"
        case emptyName = "First name cannot be empty"
        case nameFormat = "Name must only contain letters"
        case invalidPhone = "Phone number should only include numbers"
        case passwordFormat = "Password must be at least 8 characters long, consist of 1 number and 1 capital"
        case passwordMismatch = "Passwords entered do not match"
    }
    
    static func isValidRegistration(info : RegistrationInfo) -> Bool
    {
       return isValidEmail(info.email) && passwordsMatch(pass1: info.password, pass2: info.confirm)
                && validPassword(str: info.password) && validNameLength(str: info.first)
    }
    
    static func isValidLogin(info : LoginInfo) -> Bool
    {
        return isValidEmail(info.email)
    }
    
    static func registrationErr(info: RegistrationInfo) -> String
    {
        if !validNameFormat(str: info.first)
        {
            return infoErr.nameFormat.rawValue
        }
        
        if !validNameLength(str: info.first)
        {
            return infoErr.emptyName.rawValue
        }
        

        if !validPhoneNumber(str: info.phone)
        {
            return infoErr.invalidPhone.rawValue
        }
        
        if !isValidEmail(info.email)
        {
            return infoErr.invalidEmail.rawValue
        }
        
        if !validPassword(str: info.password)
        {
            return infoErr.passwordFormat.rawValue
        }
        
        if !passwordsMatch(pass1: info.password, pass2: info.confirm)
        {
            return infoErr.passwordMismatch.rawValue
        }
        
        return ""
    }
    
    static func loginErr(info: LoginInfo) -> String
    {
        if !isValidEmail(info.email)
        {
            return infoErr.invalidEmail.rawValue
        }
    
        return ""
    }
    
    static func isValidEmail(_ string: String?) -> Bool
    {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let p = NSPredicate(format:"SELF MATCHES %@", regex)
        return p.evaluate(with: string)
    }
    
    static func validPassword(str : String) -> Bool
    {
        return str.count >= passLength && hasUpper(str: str)
    }
    
    static func validNameLength(str : String) -> Bool
    {
        return str.count > 0
    }
    
    static func validNameFormat(str : String) -> Bool
    {
        return true
    }
    
    static func validPhoneNumber(str: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: str)
        return result
    }
    
    static func passwordsMatch(pass1 : String, pass2: String) -> Bool
    {
        return pass1 == pass2
    }
    
    static func hasUpper(str : String) -> Bool
    {
        let regex  = ".*[A-Z]+.*"
        let p = NSPredicate(format:"SELF MATCHES %@", regex)
        return p.evaluate(with: str)
    }
}
