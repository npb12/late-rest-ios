//
//  OnboardingPages.swift
//  Hank
//
//  Created by Neil Ballard on 11/6/18.
//  Copyright © 2018 Socal Labs LLC. All rights reserved.
//

import Foundation
import UIKit

struct OnboardingPages {
    
    let title : String
    let placeholder : String
}

let pages = [OnboardingPages(title: "Step 1 of 3", placeholder: "Full Name"),
             OnboardingPages(title: "Step 2 of 3", placeholder: "Email"),
             OnboardingPages(title: "Step 3 of 3", placeholder: "Password - minimum of 8 characters")]
