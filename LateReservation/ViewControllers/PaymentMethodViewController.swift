//
//  PaymentInfoViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class PaymentMethodViewController : UIViewController
{
    let line : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:20)
        label.textColor = UIColor.black
        label.text = "Late Reservation is currently free to use. Enjoy!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = "Payment Method"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 16)!]
    }
    
    func setupviews()
    {
        view.addSubview(headerLabel)
        headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -10).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(line)
        line.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 75).isActive = true
        line.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -75).isActive = true
        line.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -30).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    
}
