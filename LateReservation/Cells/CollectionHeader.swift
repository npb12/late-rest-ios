//
//  CollectionHeader.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/21/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class CollectionHeader: UICollectionViewCell  {
    
    override init(frame: CGRect)    {
        super.init(frame: frame)
        setupHeaderViews()
    }
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:32)
        label.textColor = UIColor.header
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:14)
        label.textColor = UIColor.subheader
        label.text = "Nearby"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupHeaderViews()   {
        addSubview(headerLabel)
        
        let width = UIScreen.main.bounds.width
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        //headerLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
