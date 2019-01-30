//
//  NearbyRestaurants.swift
//  LateReservation
//
//  Created by Neil Ballard on 10/12/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class NearbyRestaurantsViewController : BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ReservationSuccessDelegate
{
    var nearby = [Restaurant]()
    var manager: LRLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults.setReturningUser(status: true)
        
        setupView()
        getData()
    }
    
    let collectionView : UICollectionView = {
        let layout = FlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.decelerationRate = UIScrollViewDecelerationRateNormal
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.layer.masksToBounds = true
        return view
    }()
    
    func setupView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(AllRestaurantsCell.self, forCellWithReuseIdentifier: "nearbyCell")
        collectionView.register(AllHeaderCell.self, forSupplementaryViewOfKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getData()
    {
        
        showIndicator("Finding Restaurants", 0.0, completion: {})
        manager = LRLocationManager()
        manager!.fetchWithCompletion {location, error in
            // fetch location or an error
            if let loc = location {
                
                if Defaults.isLoggedIn()
                {
                    LRServer.shared.getFavorites() {
                        (favorites: [Favorite]?, error: Error?) in
                        DispatchQueue.main.async {
                            self.hideIndicator()
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
    
    func getNearby(_ loc : CLLocation)
    {
        LRServer.shared.getNearbyRestaurants(loc, true) {
            (data: [Restaurant]?, error: Error?) in
            DispatchQueue.main.async {
                self.hideIndicator()
                // nearby = restaurants
                // self.
                if let restaurants = data
                {
                    self.nearby = restaurants
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
        if let detailViewController = segue.destination as? DetailViewController
        {
            if let restaurant = sender as? Restaurant
            {
                detailViewController.restaurant = restaurant
                detailViewController.reservationDelegate = self
            }
        }
    }
    
    //collectionview
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let rest = nearby[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: rest);
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return nearby.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearbyCell", for: indexPath) as! AllRestaurantsCell
        let restaurant = nearby[indexPath.row]
        cell.card = restaurant
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        if Favorites.isFavorited(id: restaurant.id)
        {
            cell.likeImg.image = #imageLiteral(resourceName: "like_active")
        }
        else
        {
            cell.likeImg.image = #imageLiteral(resourceName: "like_img")
        }
        cell.likeButton.isHidden = false
        cell.likeImg.isHidden = false
        
        
        /*
        cell.timesView.tables?.removeAll()
        cell.timesView.tables = restaurant.reservations
        cell.timesView.collectionView.reloadData()
        */
        
        let city = LRParser.getCity(restaurant)
        
        if let lastLocation = Defaults.getLastLocation()
        {
            let restaurantLocation = CLLocation(latitude: restaurant.lat, longitude: restaurant.lon)
            let locationText = String(format: "%@  •  %.1f mi", city, LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation))
            cell.locationLabel.text = locationText
        }
        else
        {
            cell.locationLabel.text = city
        }
        
        if restaurant.reservations.count > 0
        {
            let tables = restaurant.reservations
            cell.discountLabel.text = String(format: "%d%% OFF", tables[0].discount)
            cell.timeLabel.font = UIFont(name:"SourceSansPro-Regular",size:13)
            cell.discountView.isHidden = false
            cell.emptyView.isHidden = true
            
            /*
             cell.timesView.containerType = ContainerType.nearby
             cell.timesView.tables?.removeAll()
             cell.timesView.tables = restaurant.reservations
             cell.timesView.collectionView.reloadData()
             */
            
            cell.timeLabel.text = String(format: "Available + %d More", tables.count)
            
        }
        else
        {
            cell.timeLabel.text = "Nothing Listed Right Now"
            cell.discountView.isHidden = true
            cell.timeLabel.font = UIFont(name:"SourceSansPro-Regular",size:13)
            cell.emptyView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            if layout.scrollDirection == .horizontal
            {
                return CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.4)
            }
        }
        
        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height * 0.375)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "header", for: indexPath) as! AllHeaderCell
        header.doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        
        if nearby.count == 0
        {
            header.headerLabel.text = "We're Growing!"
            header.descLabel.text = "We're coming to your area soon. Stayed tuned and check back shortly!"
        }
        else
        {
            header.headerLabel.text = "Get Started"
            header.descLabel.text = "Like your favorite restaurants to get notified for exclusive discounts"
        }

        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.225)
    }
    
    @objc func doneTapped()
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        
        
        if Defaults.isLoggedIn()
        {
            let indexPath = IndexPath.init(row: sender.tag, section: 0)
            let rest = nearby[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! AllRestaurantsCell
            if Favorites.isFavorited(id: rest.id)
            {
                cell.likeImg.image = #imageLiteral(resourceName: "like_img")
                if let favId = Favorites.getFavoritedId(id: rest.id)
                {
                    LRServer.shared.deleteFavorite(favId, completion: {
                        DispatchQueue.main.async {
                            self.updateTabVC()
                        }
                    })
                }
            }
            else
            {
                cell.likeImg.image = #imageLiteral(resourceName: "like_active")
                AppDelegate.shared().registerForPushNotifications()
                LRServer.shared.addFavorite(rest, completion: {
                    DispatchQueue.main.async {
                        self.updateTabVC()
                    }
                })
            }
        }
        else
        {
            if let tabBar: TabBarController = self.tabBarController as? TabBarController
            {
                tabBar.goToLogin()
            }
        }
    }
    
    func updateTabVC()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.updateFavorites()
        }
    }
    
    func reservationSucceeded(_ sender: DetailViewController, _ success: Bool) {
        
        if success
        {
            showResult("Booking Confirmed", true, completion: {
                self.hideIndicator()
            })
        }
        else
        {
            showResult("Booking Failed", false, completion: {
                self.hideIndicator()
            })
        }
    }
}
