//
//  OnboardingItemView.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class OnboardingItemView: UICollectionViewCell {
    
    var onboardingPageInfo : OnboardingPages? {
        didSet {
            if let title = onboardingPageInfo?.title {
                titleLabel.text = title
            }
            
            if let placeholder = onboardingPageInfo?.placeholder
            {
                textField.placeholder = placeholder
            }
        }
    }
    
    let closeImg : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "back_ios")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textField : VersatileTextField = {
        let field = VersatileTextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        field.placeholderFont = UIFont(name:"SourceSansPro-SemiBold",size:16)
        field.textColor = UIColor.black
        field.lineColor = UIColor.grayBg
        field.placeholderColor = UIColor.LRLightGray
        field.selectedLineColor = UIColor.header
        field.selectedTitleColor = UIColor.blackBg
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:16)
        label.textColor = UIColor.header
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnShadow : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.LRPinkShadow.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.4;
        view.layer.shadowRadius = 5.0;
        // view.layer.masksToBounds = false
        return view
    }()
    
    let startButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name:"SourceSansPro-SemiBold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.LRPink
        button.layer.borderColor = UIColor.LRPink.cgColor
        button.layer.borderWidth = 0.5
        button.alpha = 0.2
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = 10
        //button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupFonts()
    }
    
    func setupView(){
        
        // Set View Background Color
        backgroundColor = UIColor.white
        
        
        addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        //closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        closeButton.addSubview(closeImg)
        closeImg.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor).isActive = true
        closeImg.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
      //  closeImg.widthAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 0.8).isActive = true
       // closeImg.heightAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 0.8).isActive = true
        
        
        addSubview(textField)
        textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let offset = UIScreen.main.bounds.height * 0.125
        addSubview(btnShadow)
        btnShadow.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: offset * 0.3).isActive = true
        btnShadow.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        btnShadow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        btnShadow.heightAnchor.constraint(equalToConstant: offset * 0.65).isActive = true
        
        
        btnShadow.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: btnShadow.topAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: btnShadow.bottomAnchor).isActive = true
        startButton.leadingAnchor.constraint(equalTo: btnShadow.leadingAnchor, constant: 0).isActive = true
        startButton.trailingAnchor.constraint(equalTo: btnShadow.trailingAnchor, constant: 0).isActive = true
        
        // Setup Contraints and Views
        addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func setupFonts()
    {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            titleLabel.font = UIFont(name:"SourceSansPro-Regular",size:21)
            textField.font = UIFont(name:"SourceSansPro-SemiBold",size:24)
            textField.placeholderFont = UIFont(name:"SourceSansPro-SemiBold",size:22)
        }
    }
}
