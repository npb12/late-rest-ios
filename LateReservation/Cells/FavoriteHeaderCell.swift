//
//  FavoriteHeaderCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 11/11/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class FavoriteHeaderCell: CollectionHeader {
    
    override func setupHeaderViews() {
        addSubview(headerLabel)
        
        let width = UIScreen.main.bounds.width
        headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        //headerLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
    }
    
}
