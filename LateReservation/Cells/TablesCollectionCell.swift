//
//  TablesCollectionCell.swift
//  LateOwner
//
//  Created by Neil Ballard on 10/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit


class TablesCollectionCell : UICollectionViewCell
{
        
    let viewContainer : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.LLDiv.cgColor
        view.backgroundColor = UIColor.main
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 2.5
        return view
    }()

    /*
    let slot : UIButton = {
        let button = UIButton()
        button.setTitle("6:15 PM", for: .normal)
        button.backgroundColor = UIColor.purpleMain
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 14)//UIFont.boldSystemFont(ofSize: 16)
    //    button.layer.borderColor = UIColor.purpleMain.cgColor
    //    button.layer.borderWidth = 0.75
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }() */
    
    let slot : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:16)
        label.textColor = .header//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /*
    let slot : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:16)
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
    }() */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews()
    {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    
        viewContainer.addSubview(slot)
        slot.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -2.5).isActive = true
        slot.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 2.5).isActive = true
        slot.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 2.5).isActive = true
        slot.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: -2.5).isActive = true
    }
}
