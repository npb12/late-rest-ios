//
//  DetailCardCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit
/*
class DetailCardCell: UITableViewCell {
    
    var card : Restaurant? {
        didSet {
            if let name = card?.name
            {
                titleLabel.text = name
            }
            
            if let img = card?.img {
                
                imgView.image = img
                //imageView.imageFromURL(urlString: img)
            }
            
            if let discount = card?.discount
            {
                // discountLabel.text = String(format: "%d\% Off", discount)
             //   discountLabel.text = "15% Off"
            }
            
            if let location = card?.location
            {
                locationLabel.text = location
            }
            
            if let time = card?.time
            {
               // timeLabel.text = time
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    /*
     let botomView : UIVisualEffectView = {
     let view = UIVisualEffectView()
     view.effect = UIBlurEffect(style: .dark)
     view.translatesAutoresizingMaskIntoConstraints = false
     return view
     }() */
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.title
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        label.textColor = .subheader//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        
        
        bottomView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        
        bottomView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
} */
