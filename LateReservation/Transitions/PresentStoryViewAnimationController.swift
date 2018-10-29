//
//  StoryViewAnimationController.swift
//  AppStoreClone
//
//  Created by Phillip Farrugia on 6/17/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit

internal class PresentStoryViewAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    internal var selectedCardFrame: CGRect = .zero
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1
        
        let containerView = transitionContext.containerView
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? TabBarController,
        let toViewController = transitionContext.viewController(forKey: .to) as? DetailViewController else {
            return
        }
        
        
        
        fromViewController.setTabBarVisible(visible: false, animated: true)
        
        // 2
        containerView.addSubview((toViewController.view)!)
        toViewController.positionContainer(left: 5.0,
                                           right: 5.0,
                                           top: selectedCardFrame.origin.y,
                                           bottom: 0.0)
        toViewController.setHeaderHeight(self.selectedCardFrame.size.height)//- 40.0)
        toViewController.configureRoundedCorners(shouldRound: true)
        

        // 3
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            toViewController.positionContainer(left: 0.0,
                                               right: 0.0,
                                               top: 0.0,
                                               bottom: 0.0)
            toViewController.setHeaderHeight(UIScreen.main.bounds.height)
            toViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            toViewController.configureRoundedCorners(shouldRound: false)
        }) { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
}
