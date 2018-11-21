//
//  PrivacyViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class PrivacyViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = "Privacy Policy"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}
