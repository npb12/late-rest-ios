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
        label.font = UIFont(name:"SourceSansPro-Regular",size:28)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let venueLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Light",size:20)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:35)
        label.textColor = .LRRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountFormatter : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:15)
        label.textColor = .LRRed
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.75
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: "%\noff")
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        return label
    }()
    
    let directionsButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mapColor
        button.setTitle("Get Directions", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 18)
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
        discountLabel.text = String(format: "%d", res.discount)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
        
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
        
        view.addSubview(discountLabel)
        discountLabel.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 20).isActive = true
        discountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -5).isActive = true
        
        view.addSubview(discountFormatter)
        discountFormatter.topAnchor.constraint(equalTo: discountLabel.topAnchor, constant: 5).isActive = true
        discountFormatter.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 2).isActive = true
        
        view.addSubview(directionsButton)
        directionsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
        directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        directionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0).isActive = true
        directionsButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
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
