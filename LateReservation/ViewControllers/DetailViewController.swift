//
//  DetailViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DetailViewController : BaseViewController, ReservationAvailableDelegate
{
    @IBOutlet var reserveButton: UIButton!
    @IBOutlet var buttonBottom: NSLayoutConstraint!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet var likeBtn: UIBarButtonItem!
    var restaurant = Restaurant()
    var reservationDelegate : ReservationSuccessDelegate?
    
    var timesViewHeight : NSLayoutConstraint?
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let webLink : UIButton = {
        let link = UIButton()
        link.setTitleColor(UIColor.header, for: .normal)
        link.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 16)
        link.backgroundColor = .clear
        link.addTarget(self, action: #selector(linkTapped), for: .touchUpInside)
        link.titleLabel?.textAlignment = .left
        link.translatesAutoresizingMaskIntoConstraints = false
        return link
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:26)
        label.textColor = UIColor.title
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:12)
        label.textColor = .header
        label.text = "About"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-Regular",size:16)
        label.textAlignment = .left
        label.textColor = UIColor.subheader
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:12)
        label.textColor = .subheader
        label.textAlignment = .left
     //   label.text = "2.1 mi - Melbourne Beach"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availableHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:12)
        label.textColor = .header
        label.text = "Available Times"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /*
    let timesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Bold",size:18)
        label.textColor = .title
       // label.text = "6:15 PM  7:00 PM  8:25 PM"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() */
    
    let timesView : TablesContainerView = {
        let view = TablesContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emptyView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    let emptyLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-Regular",size:18)
        label.textColor = UIColor.white
        label.text = "No Discounts"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emptyLabel2 : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-Light",size:15)
        label.textColor = UIColor.white
        label.text = "Today"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc func linkTapped() {
        if let url = URL(string: restaurant.website), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = restaurant.restaurantName
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        let height = webLink.frame.maxY + reserveButton.frame.size.height + 50
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
    func setupView()
    {
        reserveButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 19)//UIFont.systemFont(ofSize: 19, weight: .semibold)
        reserveButton.backgroundColor = UIColor.LROffTone//UIColor.black.withAlphaComponent(0.8)
        reserveButton.setTitleColor(.white, for: .normal)
      //  reserveButton.layer.borderColor = UIColor.LLDiv.cgColor
      //  reserveButton.layer.borderWidth = 1
        
        containerView.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3).isActive = true
        
        imgView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: imgView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: imgView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: imgView.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: imgView.bottomAnchor).isActive = true
        
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        emptyView.addSubview(emptyLabel2)
        emptyLabel2.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor).isActive = true
        emptyLabel2.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(availableHeaderLabel)
        availableHeaderLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
        availableHeaderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        
        containerView.addSubview(timesView)
        timesView.topAnchor.constraint(equalTo: availableHeaderLabel.bottomAnchor, constant: 5).isActive = true
        timesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        timesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -UIScreen.main.bounds.width * 0.195).isActive = true
        timesViewHeight = timesView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.05)
        timesViewHeight?.isActive = true
        
        containerView.addSubview(descHeaderLabel)
        descHeaderLabel.topAnchor.constraint(equalTo: timesView.bottomAnchor, constant: 20).isActive = true
        descHeaderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        
        containerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: descHeaderLabel.bottomAnchor, constant: 10).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(webLink)
        webLink.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10).isActive = true
        webLink.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
    //    webLink.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
    }
    
    func setData()
    {
        titleLabel.text = restaurant.restaurantName
        imgView.imageFromURL(urlString: restaurant.photo)
        let webText = String(format: "%@ website", restaurant.restaurantName)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: webText)
        attributeString.addAttribute(NSAttributedStringKey.underlineStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        webLink.setAttributedTitle(attributeString, for: .normal)
        descLabel.text = restaurant.description
        
        if restaurant.reservations.count > 0
        {
            setReservationData()
        }
        else
        {
            //timesLabel.text = "No tables available currently"
            reserveButton.setTitle("BOOK IT", for: .normal)
            reserveButton.isUserInteractionEnabled = false
            reserveButton.isHidden = true
            
            if let lastLocation = Defaults.getLastLocation()
            {
                LRServer.shared.getTables(restaurant, lastLocation) {
                    () in
                    DispatchQueue.main.async {
                        if self.restaurant.reservations.count > 0
                        {
                            self.setReservationData()
                        }
                    }
                }
            }
        }
        
        if Favorites.isFavorited(id: restaurant.id)
        {
            likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
        }
        else
        {
            likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
        }
        
        if let lastLocation = Defaults.getLastLocation()
        {
            let restaurantLocation = CLLocation(latitude: restaurant.lat, longitude: restaurant.lon)
            let locationText = String(format: "%@  •  %.1f mi", restaurant.location, LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation))
            locationLabel.text = locationText
        }
        else
        {
            locationLabel.text = restaurant.location
        }
        
        if timesView.tables.count > 0
        {
            timesView.emptyLabel.isHidden = true
            emptyView.isHidden = true
            emptyLabel.isHidden = true
            emptyLabel2.isHidden = true
        }
        else
        {
            timesView.emptyLabel.isHidden = false
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyLabel2.isHidden = false
        }
    }

    func setReservationData()
    {
        if restaurant.reservations.count > 0
        {
            var high = restaurant.reservations[0].discount
            for res in restaurant.reservations
            {
                if res.discount > high
                {
                    high = res.discount
                }
            }
            
            let buttonTitle = String(format: "BOOK IT | %d%% OFF", high)
            reserveButton.setTitle(buttonTitle, for: .normal)
        }
        
        reserveButton.isUserInteractionEnabled = true
        reserveButton.isHidden = false
        timesView.tables.removeAll()

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        formatter.timeZone = TimeZone.current
        
        let ampmformatter = DateFormatter()
        ampmformatter.dateFormat = "a"
        ampmformatter.timeZone = TimeZone.current
        
        //remove duplicates for instead of showing a bunch of repeats
        for res in restaurant.reservations
        {
            if let startTime = res.startTime, let endTime = res.endTime
            {
                let startString = formatter.string(from: startTime)
                let endString = formatter.string(from: endTime)
                let am_pm = ampmformatter.string(from: endTime)
                let fullStr = String(format: "%@ - %@ %@", startString, endString, am_pm)
                timesView.tables.appendIfNotContains(fullStr)
            }
        }
        
        timesView.collectionView.reloadData()
        
        //2 = 1 row, so view needs to be expanded
        if timesView.tables.count > 2
        {
            let offset : CGFloat = CGFloat(timesView.tables.count / 2) + 1
            let size = (UIScreen.main.bounds.height * 0.05) * offset
            timesViewHeight?.isActive = false
            timesViewHeight = timesView.heightAnchor.constraint(equalToConstant: size)
            timesViewHeight?.isActive = true
        }
        
        if timesView.tables.count > 0
        {
            timesView.emptyLabel.isHidden = true
            emptyView.isHidden = true
            emptyLabel.isHidden = true
            emptyLabel2.isHidden = true
        }
        else
        {
            timesView.emptyLabel.isHidden = false
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            emptyLabel2.isHidden = false
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeRest(_ sender: Any)
    {
        
        if Defaults.isLoggedIn()
        {
            if Favorites.isFavorited(id: restaurant.id)
            {
                likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
                if let favId = Favorites.getFavoritedId(id: restaurant.id)
                {
                    LRServer.shared.deleteFavorite(favId, completion: {
                        DispatchQueue.main.async {
                            //             self.updateTabVC()
                        }
                    })
                }
            }
            else
            {
                likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
                AppDelegate.shared().registerForPushNotifications()
                LRServer.shared.addFavorite(restaurant, completion: {
                    DispatchQueue.main.async {
                        //           self.updateTabVC()
                    }
                })
            }
            
            LRServer.shared.getFavorites() {
                (favorites: [Favorite]?, error: Error?) in
            }
            
            NotificationCenter.default.post(name: Notification.Name.favoritesDidChange, object: nil)
        }
        else
        {
            showLoginOption("favorite a restaurant")
        }
    }
    
    func showLoginOption(_ str : String)
    {
        let alert = UIAlertController(title: "Logged Out", message: "Your must be logged in to \(str). Log In?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
            CATransaction.begin()
            self.navigationController?.popViewController(animated: true)
            CATransaction.setCompletionBlock({ [weak self] in
                NotificationCenter.default.post(name: Notification.Name.userNeedsLogin, object: nil) })
            CATransaction.commit()
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (_) in
            alert.dismiss(animated: false, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chooseViewController = segue.destination as? ChooseReservationViewController
        {
            chooseViewController.restaurant = restaurant
            chooseViewController.delegate = self
        }
    }
    
    @IBAction func reserveAction(_ sender: Any)
    {
        if Defaults.isLoggedIn()
        {
            performSegue(withIdentifier: "chooseSegue", sender: self)
        }
        else
        {
            showLoginOption("book a discount")
        }
    }
    
    func reservationIsAvailable(_ sender: ChooseReservationViewController, _ tableId: Int, _ party: Int, _ available: Bool) {
        
        if !available
        {
            showIndicator("Reservation Unavailable", 2.0, completion: {
                self.reservationDelegate?.reservationSucceeded(self, false)
                self.navigationController?.popViewController(animated: false)
            })
        }
        else
        {
            showIndicator("Booking Discount", 2.0, completion: {
                LRServer.shared.reserve(tableId, party) {
                    (error: Error?) in
                    DispatchQueue.main.async {
                        self.hideIndicator()
                        if error == nil
                        {
                            self.reservationDelegate?.reservationSucceeded(self, true)
                        }
                        else
                        {
                            self.reservationDelegate?.reservationSucceeded(self, false)
                        }
                        self.navigationController?.popViewController(animated: false)
                    }
                }
            })
        }
    }
}
