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
    var reservation = LateReservation()
    
    var delegate : ConfirmReservationDelegate?
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-Regular",size:22)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:14)
        label.textColor = .white//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.backgroundColor = UIColor.LRBlue
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.layer.borderColor = UIColor.LRBlue.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2.5
        label.textContainerInset = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let whoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:18)
        label.textColor = .title
        label.textAlignment = .center
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
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    let okButton : UIButton = {
        let button = UIButton()
        button.setTitle("DONE", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont(name:"SourceSansPro-Bold",size:18)//
        button.setTitleColor(UIColor.blueLiteTwo, for: .normal)
        button.layer.borderColor = UIColor.LLDiv.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        
        if let restaurant = reservation.restaurant
        {
            titleLabel.text = String(format: "%@", restaurant.restaurantName)
            imageView.imageFromURL(urlString: restaurant.photo)
        }
        
        whoLabel.text = String(format: "%d people at %d%% off", reservation.party, reservation.discount)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd 'at' h:mm a"
        formatter.timeZone = TimeZone.current
        let dateString = formatter.string(from: reservation.reservationTime!)
        timeLabel.text = String(format: "%@", dateString)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupView()
    {
        view.addSubview(alphaView)
        alphaView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        alphaView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        alphaView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        alphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        
        view.addSubview(containerFrame)
        containerFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerFrame.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        containerFrame.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
        setupContainerShadow()
        
        let imgSize = UIScreen.main.bounds.width * 0.3
        view.addSubview(imageView)
        imageView.heightAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imgSize).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: containerFrame.topAnchor, constant: 10).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imgSize / 2
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 2
        
        
        containerFrame.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -25).isActive = true
        
        
        //   timeLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        //   timeLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(whoLabel)
        whoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        whoLabel.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 30).isActive = true
        whoLabel.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -30).isActive = true
        
        containerFrame.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: whoLabel.bottomAnchor, constant: 20).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: containerFrame.centerXAnchor).isActive = true
        
        containerFrame.addSubview(okButton)
        okButton.bottomAnchor.constraint(equalTo: containerFrame.bottomAnchor, constant: 0).isActive = true
        okButton.trailingAnchor.constraint(equalTo: containerFrame.trailingAnchor, constant: -0).isActive = true
        okButton.leadingAnchor.constraint(equalTo: containerFrame.leadingAnchor, constant: 0).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08).isActive = true
        okButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 35).isActive = true
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
        
        self.containerFrame.layer.cornerRadius = 5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.075
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
    @objc func confirmTapped()
    {
        dismiss(animated: false, completion: {
            //self.delegate?.didConfirmReservation(self, self.reservation.tableId)
        })
    }
    
    @objc func cancelTapped()
    {
        dismiss(animated: false, completion: nil)
    }
}

/*    : UIViewController
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
*/
