//
//  ConfirmReservationViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/27/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class ConfirmReservationViewController : UIViewController
{
    var reservation = LateReservation()
    var party = 0

    var delegate : ConfirmReservationDelegate?

    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"Helvetica-Bold",size:20)
        label.textAlignment = .center
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:17)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:18)
        label.textColor = .title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alphaView : UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.black
        view.alpha = 0.45
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerFrame : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let confirmButton : UIButton = {
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name:"Helvetica-Bold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.LLGray, for: .normal)
        button.titleLabel?.font = UIFont(name:"Helvetica-Bold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        if let restaurant = reservation.restaurant
        {
            titleLabel.text = String(format: "Confirm Reservation to %@", restaurant.restaurantName)
        }
        
        if let user = Defaults.getUser()
        {
            if let name = user.first
            {
                whoLabel.text = String(format: "For %@: %d", name, party)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd 'at' h:mm a"
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: reservation.reservationTime!)
        timeLabel.text = String(format: "Today, %@", dateString)
    }
    
    func setupView()
    {
        view.addSubview(alphaView)
        alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alphaView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(containerFrame)
        containerFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        containerFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        containerFrame.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerFrame.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -25).isActive = true
        
        containerFrame.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(whoLabel)
        whoLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        whoLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        whoLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: containerFrame.bottomAnchor, constant: 0).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
        cancelButton.topAnchor.constraint(equalTo: whoLabel.bottomAnchor, constant: 35).isActive = true
        
        containerFrame.addSubview(confirmButton)
        confirmButton.bottomAnchor.constraint(equalTo: containerFrame.bottomAnchor, constant: 0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
    }
    
    @objc func confirmTapped()
    {
        dismiss(animated: false, completion: {
            self.delegate?.didConfirmReservation(self, self.reservation.tableId)
        })
    }
    
    @objc func cancelTapped()
    {
        dismiss(animated: false, completion: nil)
    }
}
