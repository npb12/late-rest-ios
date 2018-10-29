//
//  DismissStoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/18/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import Foundation

import UIKit

internal class DismissStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? TabBarController else {
                return
        }
        
        // 2
     //   toViewController.view.isHidden = true
     //   containerView.addSubview(toViewController.view)
        
        toViewController.setTabBarVisible(visible: true, animated: true)
        
        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.05, options: .curveEaseInOut, animations: {
            fromViewController.positionContainer(left: self.selectedCardFrame.origin.x,
                                                 right: self.selectedCardFrame.origin.x + self.selectedCardFrame.size.width,
                                                 top: self.selectedCardFrame.origin.y,
                                                 bottom: 0.0)
            fromViewController.setHeaderHeight(self.selectedCardFrame.size.height)
            fromViewController.configureRoundedCorners(shouldRound: true)
        }) { (_) in
       //     toViewController.view.isHidden = false
        }
        
        UIView.animate(withDuration: 0, delay: duration - 0.25, animations: {
        }, completion: { (finished) in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
