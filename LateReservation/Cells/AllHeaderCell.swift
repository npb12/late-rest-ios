//
//  AllHeaderCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class AllHeaderCell: UICollectionViewCell  {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Bold",size:32)
        label.textColor = UIColor.header
        label.text = "Get Started"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:16)
        label.textColor = UIColor.subheader
        label.text = "Like your favorites restaurants to get notified for exclusive discounts"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton : UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.blueLiteTwo, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupHeaderViews()   {
        
        addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
       // doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
      //  doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(headerLabel)
        let width = UIScreen.main.bounds.width
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 5).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 2.5).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
