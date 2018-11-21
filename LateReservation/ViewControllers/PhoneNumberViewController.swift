//
//  PhoneNumberViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class PhoneNumberViewController : UIViewController
{
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let accountLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subheader
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:15)
        label.text = "Contact Number"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let credentialLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.header
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .main
        setupViews()
        
        if let user = Defaults.getUser()
        {
            credentialLabel.text = user.number
        }
    }
    
    func setupViews() {
        
        
        view.addSubview(accountLabel)
        accountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        accountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        
        view.addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 10).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        viewContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        
        viewContainer.addSubview(credentialLabel)
        credentialLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        credentialLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20).isActive = true

        viewContainer.layoutIfNeeded()
        
        viewContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        viewContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.09), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.09))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = "Phone Contact"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
    }
    
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}
