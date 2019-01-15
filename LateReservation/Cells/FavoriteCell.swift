//
//  FavoriteCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/21/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCell : LateTableCell
{
    override func applyShadow(width: CGFloat, height: CGFloat) {
      /*  if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 5.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 4.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.15
            shadowView.layer.shadowPath = shadowPath.cgPath
        } */
    }
    
    override func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        viewContainer.backgroundColor = .white
        
        /*
        viewContainer.addSubview(bottomView)
        bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true */
        
        let imgSize = UIScreen.main.bounds.width * 0.24
        viewContainer.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imgSize / 2
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 2
        
        viewContainer.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 0).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 0).isActive = true
        titleLabel.font = UIFont(name:"SourceSansPro-SemiBold",size:16)
        titleLabel.textAlignment = .center
        
        
        /*
        imageView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        emptyView.backgroundColor = UIColor.black.withAlphaComponent(0.2) */
        
        /*
        viewContainer.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -15).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
        likeImg.image = UIImage.init(named: "favorite_active")
        emptyView.isHidden = false
        likeImg.alpha = 0.7 */
     //   imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor).isActive = true
     //   imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
     //   imageView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
     //   imageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        /*
        viewContainer.addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 25).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 25).isActive = true */
        

        
        /*
        bottomView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: likeImg.trailingAnchor, constant: -5).isActive = true
        
        
        viewContainer.addSubview(discountLabel)
        discountLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        discountLabel.trailingAnchor.constraint(equ
         alTo: viewContainer.trailingAnchor, constant: -10).isActive = true */
        
        /*
        bottomView.addSubview(locationLabel)
        locationLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true */
        
        /*
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
        gradientView.layer.mask = gradient */
    }
}
