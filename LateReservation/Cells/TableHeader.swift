//
//  TableHeader.swift
//  Localevel
//
//  Created by Neil Ballard on 7/21/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class TableHeader: UITableViewCell  {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupHeaderViews()
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Bold",size:32)
        label.textColor = UIColor.header
        label.numberOfLines = 1
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    func setupHeaderViews()   {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(headerLabel)
        let width = UIScreen.main.bounds.width
        headerLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20).isActive = true
        headerLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 40).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
