//
//  ArrayExt.swift
//  LateReservation
//
//  Created by Neil Ballard on 11/13/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if !contains(element) {
            append(element)
            return (true, element)
        }
        return (false, element)
    }
}
