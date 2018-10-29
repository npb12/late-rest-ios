//
//  DrawLine.swift
//  Local Level
//
//  Created by Neil Ballard on 9/21/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

extension CALayer
{
    public func drawLine(fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 0.1
        line.strokeColor = UIColor.title.cgColor
        addSublayer(line)
    }
    
    func applySketchShadow(color: UIColor,alpha:Float,x:CGFloat ,y:CGFloat,blur:CGFloat,
                           spread: CGFloat)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
