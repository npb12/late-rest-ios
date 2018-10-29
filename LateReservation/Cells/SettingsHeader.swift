//
//  SettingsHeader.swift
//  Local Level
//
//  Created by Neil Ballard on 9/22/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit


class SettingsHeader : TableHeader
{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupHeaderViews()
        
        viewContainer.layoutIfNeeded()
        viewContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: 90), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: 90))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
