//
//  VerticalPanGesture.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class LRVerticalPanGesture: UIPanGestureRecognizer
{
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent)
    {
        super.touchesMoved(touches, with: event)
        
        if state == .began
        {
            let vel = velocity(in: self.view!)
            
            if (fabs(vel.x) > fabs(vel.y))
            {
                state = .cancelled
            }
        }
    }
}
