//
//  LateTableCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class LateTableCell: UICollectionViewCell {
    
    /// Shadow View
    weak var shadowView: UIView?
    
    /// Core Motion Manager
    private let motionManager = CMMotionManager()
    
    var card : Restaurant? {
        didSet {
            
            if let name = card?.restaurantName
            {
                titleLabel.text = name
            }
            
            if let img = card?.photo {
                
                imageView.imageFromURL(urlString: img)
            }
            
            if let restaurant = card
            {                
                if let lastLocation = Defaults.getLastLocation()
                {
                    let restaurantLocation = CLLocation(latitude: restaurant.lat, longitude: restaurant.lon)
                    distanceLabel.text = String(format: "%.1f mi", LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation))
                }
            }
            
            /*
            if let reservations = card?.reservations
            {
                
                discountLabel.text = String(format: "%d\% Off", discount)
                //discountLabel.text = "15% Off"
            } */
            
            /*
            if let location = card?.location
            {
                locationLabel.text = location
            } */
            
            /*
            if let time = card?.time
            {
                timeLabel.text = time
            } */
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  self.clipsToBounds = false
        setupViews()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureShadow()
    }
    
    // MARK: - Shadow
    
    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: 20,
                                              y: 20,
                                              width: bounds.width - (2 * 20),
                                              height: bounds.height - (2 * 20)))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView
        
        self.applyShadow(width: CGFloat(-1), height: CGFloat(10))

        // Roll/Pitch Dynamic Shadow
        /*if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
                if let motion = motion {
                    let pitch = motion.attitude.pitch * 10 // x-axis
                    let roll = motion.attitude.roll * 10 // y-axis
                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
                }
            })
        } */
    }
    
    func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 5.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 5.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.25
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }
    
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.main
      //  view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let gradientView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .main
        view.layer.borderColor = UIColor.LLGray.cgColor
        view.layer.borderWidth = 1
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Light",size:13)
        label.textColor = .subheader
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Light",size:13)
        label.textColor = .subheader
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /*
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:13)
        label.textColor = .header//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "Today 4+ more"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }() */
    
    let partyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SourceSansPro-Light", size: 13)
        label.textColor = .subheader//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "Party: 2"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    /*
    let timesView : TablesContainerView = {
        let view = TablesContainerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() */
    
    let discountView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let discountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        label.textColor = UIColor.LROffTone
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "like_img")
        imageView.alpha = 0.8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Light",size:13)
        label.textColor = .LRLightGray//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(bottomView)
    //    bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        viewContainer.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        setupImageShadow()
        
        imageView.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        
        emptyView.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true

        emptyView.addSubview(emptyLabel2)
        emptyLabel2.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor).isActive = true
        emptyLabel2.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

        
        bottomView.addSubview(locationLabel)
        locationLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -self.bounds.width * 0.2).isActive = true
        
        bottomView.addSubview(distanceLabel)
        distanceLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor, constant: 0).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -20).isActive = true
        
        bottomView.addSubview(timeLabel)
        timeLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -15).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -15).isActive = true
        
        bottomView.addSubview(titleLabel)
        titleLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 0).isActive = true
        titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 10).isActive = true
        titleLabel.numberOfLines = 1
        
        viewContainer.addSubview(discountView)
        //    bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        discountView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20).isActive = true
        discountView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 0).isActive = true
        
        discountView.addSubview(discountLabel)
        discountLabel.leadingAnchor.constraint(equalTo: discountView.leadingAnchor, constant: 0).isActive = true
        discountLabel.trailingAnchor.constraint(equalTo: discountView.trailingAnchor, constant: 0).isActive = true
        discountLabel.topAnchor.constraint(equalTo: discountView.topAnchor, constant: 0).isActive = true
        discountLabel.bottomAnchor.constraint(equalTo: discountView.bottomAnchor, constant: 0).isActive = true
        
      //  discountLabel.leadingAnchor.constraint(equalTo: discountView.leadingAnchor, constant: 10).isActive = true
        
        //setupDiscountShadow()
        
        viewContainer.addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 22.5).isActive = true
        
        imageView.addSubview(gradientView)
        gradientView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -10).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: likeButton.bottomAnchor, constant: 10).isActive = true
        
        gradientView.layoutIfNeeded()
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y:0.6)
        let blackColor = UIColor.black
        gradient.colors = [blackColor.withAlphaComponent(0.0).cgColor, blackColor.withAlphaComponent(1.0), blackColor.withAlphaComponent(1.0).cgColor]
        gradient.locations = [NSNumber(value: 1.0),NSNumber(value: 0.2),NSNumber(value: 0.0)]
        gradient.frame = gradientView.bounds
        gradientView.layer.mask = gradient
    }
    
    func setupImageShadow()
    {
        self.imageView.layoutIfNeeded()
        let shadowView = UIView.init(frame: self.imageView.frame)
        shadowView.backgroundColor = .clear
        self.imageView.superview?.addSubview(shadowView)
        shadowView.addSubview(self.imageView)
        self.imageView.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.imageView.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        shadowView.layer.shadowRadius = 3
        shadowView.layer.shadowOpacity = 0.25
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0 , height:3)
        shadowView.clipsToBounds = false
    }
    
    func setupDiscountShadow()
    {
        self.discountView.layoutIfNeeded()
        let shadowView = UIView.init(frame: self.discountView.frame)
        shadowView.backgroundColor = .clear
        self.discountView.superview?.addSubview(shadowView)
        shadowView.addSubview(self.discountView)
        self.discountView.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.discountView.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.discountView.layer.cornerRadius = self.discountView.frame.size.height / 2
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowRadius = 5
        discountView.layer.borderColor = UIColor.main.cgColor
        discountView.layer.borderWidth = 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}
