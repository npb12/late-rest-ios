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
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:22)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let timeLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:14)
        label.textColor = .header//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.backgroundColor = UIColor.main
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.layer.borderColor = UIColor.LLDiv.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2.5
        label.textContainerInset = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:18)
        label.textColor = .title
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alphaView : UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.black
        view.alpha = 0.65
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerFrame : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    
    let confirmButton : UIButton = {
        let button = UIButton()
        button.setTitle("CONFIRM", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont(name:"SourceSansPro-Bold",size:18)//
        button.setTitleColor(UIColor.LROffTone, for: .normal)
        button.layer.borderColor = UIColor.LLDiv.cgColor
        button.layer.borderWidth = 1
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        if let restaurant = reservation.restaurant
        {
            titleLabel.text = String(format: "%@", restaurant.restaurantName)
            imageView.imageFromURL(urlString: restaurant.photo)
        }
        
        let ppl = party > 1 ? "people" : "person"
        
        whoLabel.text = String(format: "%d %@ at %d%% off", party, ppl, reservation.discount)

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        formatter.timeZone = TimeZone.current
        let startString = formatter.string(from: reservation.startTime!)
        let endString = formatter.string(from: reservation.endTime!)
        formatter.dateFormat = "a"
        let am_pm = formatter.string(from: reservation.endTime!)
        timeLabel.text = String(format: "Today from %@ - %@ %@", startString, endString, am_pm)
    }
    
    func setupView()
    {
        view.addSubview(alphaView)
        alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alphaView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.insertSubview(cancelButton, belowSubview: containerFrame)
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.addSubview(containerFrame)
        containerFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        containerFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
                
        let imgSize = UIScreen.main.bounds.width * 0.3
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerFrame.topAnchor, constant: 10).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imgSize / 2
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 2
        
        
        containerFrame.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -25).isActive = true
        

     //   timeLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
     //   timeLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(whoLabel)
        whoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        whoLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        whoLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: whoLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        
        containerFrame.addSubview(confirmButton)
        confirmButton.bottomAnchor.constraint(equalTo: containerFrame.bottomAnchor, constant: 0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.085).isActive = true
        confirmButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 35).isActive = true
    }
    
    func setupContainerShadow()
    {
        let shadowView = UIView.init(frame: self.containerFrame.frame)
        shadowView.backgroundColor = .clear
        self.containerFrame.superview?.addSubview(shadowView)
        shadowView.addSubview(self.containerFrame)
        self.containerFrame.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.containerFrame.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.containerFrame.layer.cornerRadius = 5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
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
