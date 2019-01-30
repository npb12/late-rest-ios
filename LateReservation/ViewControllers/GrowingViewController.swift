//
//  GrowingViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 1/29/19.
//  Copyright © 2019 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit


class GrowingViewController : UIViewController
{
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:22)
        label.text = "We're Growing!"
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.init(named: "growing_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:18)
        label.textColor = .title
        label.text = "We're coming to your area soon. Stayed tuned and check back shortly!"
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
        button.setTitle("OK", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont(name:"SourceSansPro-Bold",size:18)//
        button.setTitleColor(UIColor.LROffTone, for: .normal)
        button.layer.borderColor = UIColor.LLDiv.cgColor
        button.layer.borderWidth = 1
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
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
        
        view.addSubview(imageView)
      //  imageView.heightAnchor.constraint(equalToConstant: imgSize).isActive = true
      //  imageView.widthAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: containerFrame.topAnchor, constant: 25).isActive = true

        containerFrame.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -25).isActive = true
        
        
        //   timeLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        //   timeLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(messageLabel)
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        
        containerFrame.addSubview(confirmButton)
        confirmButton.bottomAnchor.constraint(equalTo: containerFrame.bottomAnchor, constant: 0).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor).isActive = true
        confirmButton.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.085).isActive = true
        confirmButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 35).isActive = true
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
    
    @objc func cancelTapped()
    {
        dismiss(animated: false, completion: nil)
    }
}
