//
//  NearbyViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import CoreLocation


// Subclass used to touch through the clear bottom sheet container view
class LRPassThroughContainer:UIView
{
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        for subview in subviews
        {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event)
            {
                return true
            }
        }
        
        return false
    }
}


class NearbyViewController: BaseViewController, LRMapControllerDelegate, LRSearchPositionDelegate
{
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchTop: NSLayoutConstraint!
    @IBOutlet var searchContainer: UIView!
    private var mapController: LRMapController? = nil
    private var pullSheetController: LRPullSheetController? = nil
    
    var manager: LRLocationManager?
    
    var nearby = [Restaurant]()
    
    @IBOutlet var locationContainer: UIView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var locationTop: NSLayoutConstraint!
        
    let statusView : UIVisualEffectView = {
        let visualEffect = UIVisualEffectView()
        visualEffect.effect = UIBlurEffect(style: .regular)
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        return visualEffect
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupSearchShadow()
        setupLocationShadow()
    }
    
    func setupSearchShadow()
    {
        let shadowView = UIView.init(frame: self.searchContainer.frame)
        shadowView.backgroundColor = .clear
        self.searchContainer.superview?.addSubview(shadowView)
        shadowView.addSubview(self.searchContainer)
        self.searchContainer.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.searchContainer.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.searchContainer.layer.cornerRadius = 22.5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
    func setupLocationShadow()
    {
        let shadowView = UIView.init(frame: self.locationContainer.frame)
        shadowView.backgroundColor = .clear
        self.locationContainer.superview?.addSubview(shadowView)
        shadowView.addSubview(self.locationContainer)
        self.locationContainer.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.locationContainer.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.locationContainer.layoutIfNeeded()
        self.locationContainer.layer.cornerRadius = self.locationContainer.bounds.height / 2
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        NotificationCenter.default.addObserver(self, selector:#selector(getData), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        locationContainer.isHidden = true
        view.addSubview(statusView)
        statusView.contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusView.contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusView.contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        statusView.contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    
    public func reservationFailure()
    {
        showResult("Reservation Failed", false, completion: {
            self.hideIndicator()
        })
    }
    
    @objc func getData()
    {
        showIndicator("Finding Options", 0.0, completion: {})
        manager = LRLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                Defaults.setLastLocation(location: loc)
                LRLocationManager.fetchCityAndCountry(location: loc) { city, error in
                    guard let city = city, error == nil else { return }
                    DispatchQueue.main.async {
                        self.locationLabel.text = city
                        self.locationContainer.isHidden = false
                    }
                    
                    if Defaults.isLoggedIn()
                    {
                        LRServer.shared.getFavorites() {
                            (favorites: [Favorite]?, error: Error?) in
                                DispatchQueue.main.async {
                                    
                                    if let favs = favorites
                                    {
                                        if favs.count > 0
                                        {
                                            AppDelegate.shared().registerForPushNotifications()
                                        }
                                    }
                                }
                            
                            self.getNearby(loc)

                        }
                        
                    }
                    else
                    {
                        self.getNearby(loc)
                    }
                }
            }
        }
    }
    
    func getNearby(_ loc : CLLocation)
    {
        LRServer.shared.getNearbyRestaurants(loc, false) {
            (data: [Restaurant]?, error: Error?) in
            DispatchQueue.main.async {
        
                self.hideIndicator()
                if let restaurants = data
                {
                    if let sheet = self.pullSheetController
                    {
                        sheet.updateData(restaurants)
                    }
                    
                    if let map = self.mapController
                    {
                        map.refreshMapPins(restaurants)
                    }
                }
            }
        }
    }
    
    
    /* override func viewDidLayoutSubviews() {
     let fullHeight = view.bounds.size.height
     let topOfAgentBar = agentBar.frame.origin.y
     
     let fauxHeight = fullHeight - topOfAgentBar
     
     pullSheetController?.agentInfoHeight = fauxHeight
     //UUDebugLog("AGENT BAR FRAME = \(agentBar.frame)")
     //UUDebugLog("PULL SHEET FRAME = \(pullSheetController?.view.frame)")
     }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "embedMapController")
        {
            mapController = segue.destination as? LRMapController
            mapController?.delegate = self
            updatePullSheetDelegate()
        }
        
        if (segue.identifier == "embedPullSheetController")
        {
            pullSheetController = segue.destination as? LRPullSheetController
            pullSheetController?.parentVC = self
            pullSheetController?.modalPresentationStyle = .currentContext
            pullSheetController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            pullSheetController?.positionDelegate = self
            updatePullSheetDelegate()
        }
    }
    
    private func updatePullSheetDelegate()
    {
        if (mapController != nil && pullSheetController != nil)
        {
            pullSheetController!.delegate = mapController!
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    func mapPinTapped(listing: Restaurant)
    {
        pullSheetController?.mapPinTapped(listing)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
    
    func pullSheetEnteredFull(position: CGFloat) {
    //    if position < searchContainer.frame.minY + searchContainer.frame.size.height + 20
    //    {
            UIView.animate(withDuration: 0.25, animations: {
                self.searchTop.constant = -80
                self.locationTop.constant = -80

            })
     //   }
    }
    
    func pullSheetLeftFull(position: CGFloat) {
        //    if position < searchContainer.frame.minY + searchContainer.frame.size.height + 20
        //    {
        UIView.animate(withDuration: 0.25, animations: {
            self.searchTop.constant = 10
            self.locationTop.constant = 10
        })
        //   }
    }
    
    public func getTabBar() -> UITabBar?
    {
        if let controller: TabBarController = self.tabBarController as? TabBarController
        {
            return controller.tabBar
        }
        
        return nil
    }
    
    @IBAction func listAction(_ sender: Any)
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.showNearbyList()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
