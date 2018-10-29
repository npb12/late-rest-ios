//
//  LRPullSheetChildController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

protocol LRPullSheetChildControllerDelegate
{
    func enableScrolling() //used so the pull sheet can give the children priority scrolling
}

/*class SBEditViewController: UUEditViewController
{
    //self.tabController.clearUUEditNotificationHandlers()
    //self.createNewController.registerUUEditNotificationHandlers()
    public func registerUUEditNotificationHandlers()
    {
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillShow, object: nil, queue: nil, using: handleKeyboardWillShowNotification)
        NotificationCenter.default.addObserver(forName: Notification.Name.UIKeyboardWillHide, object: nil, queue: nil, using: handleKeyboardWillHideNotification)
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextViewTextDidBeginEditing, object: nil, queue: nil, using: handleEditingStarted)
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidBeginEditing, object: nil, queue: nil, using: handleEditingStarted)
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextViewTextDidEndEditing, object: nil, queue: nil, using: handleEditingEnded)
        NotificationCenter.default.addObserver(forName: Notification.Name.UITextFieldTextDidEndEditing, object: nil, queue: nil, using: handleEditingEnded)
        //print("\n\nUUEDIT REGISTERED FOR NOTIFICATION HANDLERS!!!!\n\n")
        
    }
    
    public func clearUUEditNotificationHandlers()
    {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
}*/

class LRPullSheetChildController: LRPullSheetChildControllerDelegate
{
    func enableScrolling()
    {
        assert(false, "enableScrolling() must be implemented!!!!")
    }
}
