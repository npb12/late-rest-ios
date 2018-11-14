//
//  AllRestaurantsCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class AllRestaurantsCell : LateTableCell
{
    override func setupViews() {
        
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        viewContainer.layer.masksToBounds = true
        viewContainer.layer.cornerRadius = 10
        
        viewContainer.addSubview(bottomView)
        //    bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        viewContainer.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        
        imageView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        emptyView.addSubview(emptyLabel2)
        emptyLabel2.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor).isActive = true
        emptyLabel2.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
    
        bottomView.addSubview(timeLabel)
        timeLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -self.bounds.width * 0.2).isActive = true
        
        bottomView.addSubview(locationLabel)
        locationLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -15).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 0).isActive = true
        
        bottomView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        
        viewContainer.addSubview(discountView)
        //    bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        discountView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -15).isActive = true
        discountView.centerYAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        discountView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.16).isActive = true
        discountView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.16).isActive = true
        
        discountView.addSubview(discountLabel)
        discountLabel.centerYAnchor.constraint(equalTo: discountView.centerYAnchor, constant: 0).isActive = true
        discountLabel.trailingAnchor.constraint(equalTo: discountView.centerXAnchor, constant: 5).isActive = true
        
        discountView.addSubview(discountFormatter)
        discountFormatter.centerYAnchor.constraint(equalTo: discountView.centerYAnchor).isActive = true
        discountFormatter.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 1).isActive = true
        
        //  discountLabel.leadingAnchor.constraint(equalTo: discountView.leadingAnchor, constant: 10).isActive = true
        
        setupDiscountShadow()
        
        
        viewContainer.addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 25).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        imageView.addSubview(gradientView)
        gradientView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10).isActive = true
        
        gradientView.layoutIfNeeded()
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y:0.6)
        let blackColor = UIColor.black
        gradient.colors = [blackColor.withAlphaComponent(0.0).cgColor, blackColor.withAlphaComponent(1.0), blackColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 1.0),NSNumber(value: 0.2),NSNumber(value: 0.0)]
        gradient.frame = gradientView.bounds
        gradientView.layer.mask = gradient
    }
    
    override func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 10.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 10.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.35
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
}
