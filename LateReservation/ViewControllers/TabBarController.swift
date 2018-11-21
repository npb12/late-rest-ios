//
//  TabBarController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class TabBarController : UITabBarController, DidAuthorizeDelegate, ReservationSuccessDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.unselectedItemTintColor = UIColor.darkGray
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        drawLine(onLayer: tabBar.layer, fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        tabBar.backgroundColor = UIColor.black
        tabBar.barTintColor = UIColor.black
        
        /*
         let frost = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
         frost.frame = tabBar.bounds
         tabBar.insertSubview(frost, at: 0) */
        
        // addBadge()
        
        NotificationCenter.default.addObserver(self, selector: #selector(authExpired), name: .authDidExpire, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkForLoginStatus()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let loginViewController = segue.destination as? LoginViewController
        {
            loginViewController.delegate = self
        }
        
        if let detailViewController = segue.destination as? DetailViewController
        {
            if let restaurant = sender as? Restaurant
            {
                detailViewController.restaurant = restaurant
                detailViewController.reservationDelegate = self
            }
        }
        
        if let reservedViewController = segue.destination as? ReservedViewController
        {
            if let reservation = sender as? LateReservation
            {
                reservedViewController.reservation = reservation
                reservedViewController.modalPresentationStyle = .overFullScreen
                reservedViewController.view.backgroundColor = UIColor.clear
                reservedViewController.view.isOpaque = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       // performSegue(withIdentifier: "nearbySegue", sender: self)
    }
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 0.15
        line.strokeColor = UIColor.darkGray.cgColor
        layer.addSublayer(line)
    }
    
    func goToRestProfile(rest: Restaurant)
    {
        performSegue(withIdentifier: "detailSegue", sender: rest);
    }
    
    func didSuccessfullyLogin(_ sender: LoginViewController)
    {
        checkForLoginStatus()
        
        if !Defaults.returningUser()
        {
            showNearbyList()
        }
    }
    
    func showNearbyList()
    {
        performSegue(withIdentifier: "nearbySegue", sender: self)
    }
    
    func didSuccessfullyRegister(_ sender: OnboardingViewController) {
        checkForLoginStatus()
        
        if !Defaults.returningUser()
        {
            performSegue(withIdentifier: "nearbySegue", sender: self)
        }
    }
    
    func reservationSucceeded(_ sender: DetailViewController, _ success : Bool) {
        
        if success
        {
            if let reservationsViewController = getReservationsController()
            {
                self.selectedIndex = 2
                reservationsViewController.getData()
                reservationsViewController.reservationSuccess()
            }
        }
        else
        {
            if let nearbyViewController = getNearbyController()
            {
                nearbyViewController.reservationFailure()
            }
        }
    }
    
    func updateFavorites()
    {
        if let favoritesViewController = getFavoritesController()
        {
            favoritesViewController.getData()
        }
    }
    
    func getNearbyController() -> NearbyViewController?
    {
        guard let vcs = self.viewControllers else {
            return nil
        }
        
        let index = 0
        
        if vcs.count > index
        {
            if let nearbyViewController = vcs[index] as? NearbyViewController
            {
                return nearbyViewController
            }
        }
        
        return nil
    }
    
    func getFavoritesController() -> FavoritesViewController?
    {
        guard let vcs = self.viewControllers else {
            return nil
        }
        
        let index = 1
        
        if vcs.count > index
        {
            if vcs.count > index
            {
                if let favoritesViewController = vcs[index] as? FavoritesViewController
                {
                    return favoritesViewController
                }
            }
        }
        
        return nil
    }
    
    func getReservationsController() -> ReservationsViewController?
    {
        guard let vcs = self.viewControllers else {
            return nil
        }
        
        let index = 2
        
        if vcs.count > index
        {
            if let reservationsController = vcs[index] as? ReservationsViewController
            {
                return reservationsController
            }
        }
        
        return nil
    }
    
    @objc func authExpired()
    {
        Defaults.setLoginStatus(status: false)
        checkForLoginStatus()
    }
    
    func checkForLoginStatus()
    {
        if (!Defaults.isLoggedIn())
        {
            performSegue(withIdentifier: "loginSegue", sender: self);
        }
    }
    
    func goToContactInvite()
    {
        performSegue(withIdentifier: "inviteSegue", sender: self);
    }
    
    func goToPrivacy()
    {
        performSegue(withIdentifier: "privacySegue", sender: self);
    }
    
    func goToPhoneNumber()
    {
        performSegue(withIdentifier: "phoneSegue", sender: self);
    }
    
    func goToPaymentMethod()
    {
        performSegue(withIdentifier: "paymentSegue", sender: self);
    }
    
    func goToPasswordChange()
    {
        performSegue(withIdentifier: "changePassSegue", sender: self);
    }
    
    func goToReservation(_ reservation: LateReservation)
    {
        performSegue(withIdentifier: "reservedSegue", sender: reservation)
    }
}
