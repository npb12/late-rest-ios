//
//  RunTutorialDelegate.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation

import UIKit

//
// This is the DELEGATE PROTOCOL
//

protocol DidAuthorizeDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func didSuccessfullyLogin(_ sender:LoginViewController)
    func didSuccessfullyRegister(_ sender:RegisterViewController)
}

protocol LocationDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func didUpdateLocation(_ sender:LoginViewController)
}

protocol ConfirmReservationDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func didConfirmReservation(_ sender:ConfirmReservationViewController, _ tableId : Int)
}

protocol ReservationAvailableDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func reservationIsAvailable(_ sender:ChooseReservationViewController, _ tableId : Int, _ available: Bool)
}

protocol ReservationSuccessDelegate {
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func reservationSucceeded(_ sender:DetailViewController, _ success : Bool)
}


/*
protocol StartupChangedDelegate{
    // Classes that adopt this protocol MUST define
    // this method -- and hopefully do something in
    // that definition.
    func didChangeStartup()
} */
