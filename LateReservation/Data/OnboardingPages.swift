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

let pages = [OnboardingPages(title: "Step 1 of 5", placeholder: "Name"),
             OnboardingPages(title: "Step 2 of 5", placeholder: "Phone Number"),
             OnboardingPages(title: "Step 3 of 5", placeholder: "Email"),
             OnboardingPages(title: "Step 4 of 5", placeholder: "Password"),
             OnboardingPages(title: "Step 5 of 5", placeholder: "Re-enter Password")]
