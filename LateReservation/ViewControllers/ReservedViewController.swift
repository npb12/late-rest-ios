//
//  ReservationViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/25/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class ReservedViewController : UIViewController
{
    
    var reservation : LateReservation?
    @IBOutlet var likeBtn: UIBarButtonItem!
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:25)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let venueLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:20)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.subheader
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:25)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let directionsButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle("Get Directions", for: .normal)
        button.setTitleColor(UIColor.blueLiteTwo, for: .normal)
        button.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
       // button.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        guard let res = reservation else {return}
        
        if let restaurant = res.restaurant
        {
            titleLabel.text = restaurant.restaurantName
            
            if Favorites.isFavorited(id: restaurant.id)
            {
                likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
            }
            else
            {
                likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd 'at' h:mm a"
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: res.reservationTime!)
        venueLabel.text = String(format: "Today, %@\nTable for %d", dateString, res.party)
        discLabel.text = String(format: "%d%% Off", res.discount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 16)!]
        
        guard let res = reservation else {return}
        if let restaurant = res.restaurant
        {
            self.navigationController?.navigationBar.topItem?.title = restaurant.restaurantName
        }
    }
    
    func setupView()
    {
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.2).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        
        view.addSubview(venueLabel)
        venueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        venueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        venueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(discLabel)
        discLabel.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 20).isActive = true
        discLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        discLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        view.addSubview(directionsButton)
        directionsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        directionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func closeTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func liked(_ sender: Any) {
        
        guard let res = reservation?.restaurant else {return}
        
        if Favorites.isFavorited(id: res.id)
        {
            likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
            if let favId = Favorites.getFavoritedId(id: res.id)
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
            LRServer.shared.addFavorite(res, completion: {
                DispatchQueue.main.async {
                    //           self.updateTabVC()
                }
            })
        }
        
        NotificationCenter.default.post(name: Notification.Name.favoritesDidChange, object: nil)
    }
    
}
