//
//  NotificationNames.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/10/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let favoritesDidChange = Notification.Name("favoritesDidChange")
    static let authDidExpire = Notification.Name("authDidExpire")
    static let userNeedsLogin = Notification.Name("userNeedsLogin")

}
