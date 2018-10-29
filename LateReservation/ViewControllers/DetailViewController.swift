//
//  DetailViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController : BaseViewController, ReservationAvailableDelegate
{
    @IBOutlet var reserveButton: UIButton!
    @IBOutlet var buttonBottom: NSLayoutConstraint!
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet var likeBtn: UIBarButtonItem!
    var restaurant = Restaurant()
    var reservationDelegate : ReservationSuccessDelegate?
    
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
      //  link.setTitle("https://dijonssteak.com", for: .normal)
        link.setTitleColor(UIColor.blueLiteTwo, for: .normal)
        link.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        link.backgroundColor = .clear
        link.translatesAutoresizingMaskIntoConstraints = false
        return link
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"Helvetica-Bold",size:26)
       // label.text = "Dijon's Chophouse"
        label.textAlignment = .center
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"Helvetica",size:16)
        label.textAlignment = .center
        label.textColor = UIColor.subheader
     //   label.text = "Dijon's chophouse is centrally located in beautiful Melbourne Beach. Our steak and lobster is offered with a side of horschradish that is pretty awesome. We also offer specials for events such as birthdays etc. Some more text about this place and how good it is if you eat here. Come dine with us!"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:12)
        label.textColor = .lightGray
        label.textAlignment = .center
     //   label.text = "2.1 mi - Melbourne Beach"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let availableHeaderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:15)
        label.textColor = .LLGreen
        label.text = "Available Times"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timesLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:18)
        label.textColor = .title
       // label.text = "6:15 PM  7:00 PM  8:25 PM"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    @objc func reserveTapped() {
        // let infoVC = InfoView()
        //  infoVC.modalPresentationStyle = .overCurrentContext
        //  present(infoVC, animated: true, completion: nil)
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
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Helvetica-Bold", size: 16)!]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      //  self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        let height = webLink.frame.maxY + reserveButton.frame.size.height + 50
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: height)
    }
    
    func setupView()
    {
        reserveButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 19)//UIFont.systemFont(ofSize: 19, weight: .semibold)
        reserveButton.backgroundColor = UIColor.LLGreen//UIColor.black.withAlphaComponent(0.8)
        reserveButton.addTarget(self, action: #selector(reserveTapped), for: .touchUpInside)
        
        containerView.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.3).isActive = true
        
        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25).isActive = true
        
        
        containerView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        
        containerView.addSubview(availableHeaderLabel)
        availableHeaderLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
        availableHeaderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        
        containerView.addSubview(timesLabel)
        timesLabel.topAnchor.constraint(equalTo: availableHeaderLabel.bottomAnchor, constant: 5).isActive = true
        timesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        timesLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
        
        containerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: timesLabel.bottomAnchor, constant: 20).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(webLink)
        webLink.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 10).isActive = true
        webLink.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30).isActive = true
        webLink.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30).isActive = true
    }
    
    func setData()
    {
        titleLabel.text = restaurant.restaurantName
        locationLabel.text = String(format: "%@", restaurant.location)
        imgView.imageFromURL(urlString: restaurant.photo)
        webLink.setTitle(restaurant.website, for: .normal)
        descLabel.text = restaurant.description
        
        if restaurant.reservations.count > 0
        {
            setReservationData()
        }
        else
        {
            timesLabel.text = "No tables available currently"
            reserveButton.setTitle("RESERVE", for: .normal)
            reserveButton.isUserInteractionEnabled = false
            reserveButton.alpha = 0.2
            
            LRServer.shared.getTables(restaurant) {
                () in
                DispatchQueue.main.async {
                    if self.restaurant.reservations.count > 0
                    {
                        self.setReservationData()
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
    }

    func setReservationData()
    {
        let buttonTitle = String(format: "RESERVE | %d%% OFF", (restaurant.reservations.first?.discount)!)
        reserveButton.setTitle(buttonTitle, for: .normal)
        reserveButton.isUserInteractionEnabled = true
        reserveButton.alpha = 1.0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone.current
        
        var str = ""
        for res in restaurant.reservations
        {
            if let time = res.reservationTime
            {
                let dateString = formatter.string(from: time)
                if str.isEmpty
                {
                    str = dateString
                }
                else
                {
                    str = str + " " + dateString
                }
            }
        }
        
        timesLabel.text = str
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func likeRest(_ sender: Any)
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
            LRServer.shared.addFavorite(restaurant, completion: {
                DispatchQueue.main.async {
         //           self.updateTabVC()
                }
            })
        }
        
        NotificationCenter.default.post(name: Notification.Name.favoritesDidChange, object: nil)
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
        performSegue(withIdentifier: "chooseSegue", sender: self)
    }
    
    func reservationIsAvailable(_ sender: ChooseReservationViewController, _ tableId: Int, _ available: Bool) {
        
        if !available
        {
            showIndicator("Reservation Unavailable", 2.0, completion: {
                self.reservationDelegate?.reservationSucceeded(self, false)
                self.navigationController?.popViewController(animated: false)
            })
        }
        else
        {
            showIndicator("Reserving Table", 2.0, completion: {
                LRServer.shared.reserve(tableId) {
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
