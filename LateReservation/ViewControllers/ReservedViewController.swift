//
//  ReservationViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/25/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ReservedViewController : UIViewController
{
    var reservation = LateReservation()
    var manager: LRLocationManager?
    var currentIndex = 0
    
    @IBOutlet var likeBtn: UIBarButtonItem!
    var delegate : ConfirmReservationDelegate?
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:30)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:16)
        label.textColor = .header//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.backgroundColor = UIColor.main
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.layer.borderColor = UIColor.LLDiv.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2.5
        label.textContainerInset = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:22)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let instructionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:18)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Present this to your waiting staff before receiving the bill"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pleaseLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Light",size:14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Remember to tip on the original amount!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let alphaView : UIButton = {
        let view = UIButton()
        view.backgroundColor = UIColor.black
        view.alpha = 0.45
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let containerFrame : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let chainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(patternImage: UIImage.init(named: "chain_img")!)
        return view
    }()
    
    let directionsButton : UIButton = {
        let button = UIButton()
        button.setTitle("Get Directions", for: .normal)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont(name:"SourceSansPro-SemiBold",size:18)//
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.LLDiv.cgColor
        button.addTarget(self, action: #selector(directionsTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let logoLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"Pacifico-Regular",size:14)
        label.textColor = UIColor.white
        label.text = "11th Table"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    let closeImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(imageLiteralResourceName: "close_icon")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        
        if let restaurant = reservation.restaurant
        {
            
            manager = LRLocationManager()
            manager!.fetchWithCompletion {location, error in
                // fetch location or an error
                if let loc = location {
                    let distance = LRLocationManager.distanceBetween(userLocation: loc, restaurantLocation: CLLocation(latitude: restaurant.lat, longitude: restaurant.lon))
                    if distance < 0.05
                    {
                        LRServer.shared.redeemed(self.reservation.tableId, completion: {
                            DispatchQueue.main.async {

                            }
                            })
                    }
                }
            }
            
            titleLabel.text = String(format: "%@", restaurant.restaurantName)
            imgView.imageFromURL(urlString: restaurant.photo)
            
            if Favorites.isFavorited(id: restaurant.id)
            {
                likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
            }
            else
            {
                likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
            }
        }
        
        var pplStr = "people"
        
        if reservation.party == 1
        {
            pplStr = "person"
        }
        
        whoLabel.text = String(format: "%d %@ at %d%% off", reservation.party, pplStr, reservation.discount)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d"
        let dayString = formatter.string(from: reservation.startTime!)
        formatter.dateFormat = "h:mm"
        let startString = formatter.string(from: reservation.startTime!)
        let endString = formatter.string(from: reservation.endTime!)
        formatter.dateFormat = "a"
        let am_pm = formatter.string(from: reservation.endTime!)
        formatter.timeZone = TimeZone.current
        timeLabel.text = String(format: "%@ from %@ - %@ %@", dayString, startString, endString, am_pm)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        /*
        self.navigationController?.navigationBar.topItem?.title = "Booking"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!] */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupView()
    {
        view.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.imgView.insertSubview(blurEffectView, at: 0)
        
        view.addSubview(chainView)
        chainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.addSubview(closeImage)
        closeImage.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor).isActive = true
        closeImage.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeImage.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        view.addSubview(logoLabel)
        logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        logoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: closeImage.centerYAnchor, constant: 0).isActive = true

        // imgView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3).isActive = true
        
        /*
        view.addSubview(containerFrame)
        containerFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        containerFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        containerFrame.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true */
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: cancelButton.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        
        view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        

        view.addSubview(whoLabel)
        whoLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
        whoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        whoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        view.addSubview(pleaseLabel)
        pleaseLabel.topAnchor.constraint(equalTo: whoLabel.bottomAnchor, constant: 20).isActive = true
        pleaseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        pleaseLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        

        
        //   pleaseLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        /*

        
        
*/
        
        view.addSubview(directionsButton)
        directionsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        directionsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        directionsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        directionsButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true

        view.addSubview(instructionLabel)
        instructionLabel.bottomAnchor.constraint(equalTo: directionsButton.topAnchor, constant: -50).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
    }
    
    func setupContainerShadow()
    {
        let shadowView = UIView.init(frame: self.containerFrame.frame)
        shadowView.backgroundColor = .clear
        self.containerFrame.superview?.addSubview(shadowView)
        shadowView.addSubview(self.containerFrame)
        self.containerFrame.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.containerFrame.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
       // self.containerFrame.layer.cornerRadius = 5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
    @objc func closeTapped()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func directionsTapped()
    {
        if let restaurant = self.reservation.restaurant
        {
            let coordinate = CLLocationCoordinate2DMake(restaurant.lat, restaurant.lon)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = restaurant.restaurantName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeRest(_ sender: Any)
    {
        if let restaurant = reservation.restaurant
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
    }
}
