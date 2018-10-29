//
//  LateTableCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import CoreMotion

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
            
            /*
            if let reservations = card?.reservations
            {
                
                discountLabel.text = String(format: "%d\% Off", discount)
                //discountLabel.text = "15% Off"
            } */
            
            if let location = card?.location
            {
                locationLabel.text = location
            }
            
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
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"Helvetica-Bold",size:20)
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:11)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:13)
        label.textColor = .LLGreen//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "Description"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let partyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 13)
        label.textColor = .subheader//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "Party: 2"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"Helvetica-Bold",size:15)
        label.textColor = .white//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "15%"
        label.backgroundColor = UIColor.LLGreen
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.layer.borderColor = UIColor.main.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 5
        label.textContainerInset = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let likeImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "like_img")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        viewContainer.addSubview(bottomView)
        bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true
        
        viewContainer.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        

        
        bottomView.addSubview(discountLabel)
        discountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 5).isActive = true
        discountLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10).isActive = true
    
        
        bottomView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: discountLabel.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: -5).isActive = true
        
        
        bottomView.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -5).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: -5).isActive = true
        
        
        viewContainer.addSubview(likeButton)
        likeButton.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        likeButton.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0).isActive = true
        likeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        likeButton.addSubview(likeImg)
        likeImg.centerXAnchor.constraint(equalTo: likeButton.centerXAnchor).isActive = true
        likeImg.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor).isActive = true
        likeImg.heightAnchor.constraint(equalToConstant: 25).isActive = true
        likeImg.widthAnchor.constraint(equalToConstant: 25).isActive = true

        bottomView.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 15).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: likeImg.trailingAnchor, constant: -5).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -10).isActive = true
        
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}
