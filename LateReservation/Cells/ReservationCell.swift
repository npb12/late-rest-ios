//
//  ReservationCell.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class MyReservationsCell: UICollectionViewCell {
    
    var isExpired : Bool = false
    
    var reservation : LateReservation? {
        didSet {
            
            if let title = reservation?.restaurant?.restaurantName {
                titleLabel.text = title
            }
            if let img = reservation?.restaurant?.photo {
                imageView.imageFromURL(urlString: img)
            }
            if let time = reservation?.reservationTime {
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current

                if Calendar.current.isDateInToday(time) || time > Date()
                {
                    isExpired = false
                    timeLabel.backgroundColor = UIColor.LRBlue
                    timeLabel.layer.borderColor = UIColor.LRBlue.cgColor
                    timeLabel.layer.borderWidth = 1
                    timeLabel.textColor = UIColor.white
                    formatter.dateFormat = "h:mm a"
                    self.alpha = 1.0
                    discountLabel.isHidden = false
                    discountFormatter.isHidden = false
                    timeLabel.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
                    timeLabel.textAlignment = .center
                }
                else
                {
                    timeLabel.backgroundColor = UIColor.clear
                    timeLabel.layer.borderWidth = 0
                    timeLabel.textColor = UIColor.LRBlue
                    isExpired = true
                    timeLabel.textColor = UIColor.LLGray
                    formatter.dateFormat = "MMMM dd 'at' h:mm a"
                    self.alpha = 0.3
                    discountLabel.isHidden = true
                    discountFormatter.isHidden = true
                    timeLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                    timeLabel.textAlignment = .left

                }
                
                let dateString = formatter.string(from: time)
                timeLabel.text = String(format: "%@", dateString)
            }
            
            if let location = reservation?.restaurant?.location {
                locationLabel.text = location
            }
            
            if let discount = reservation?.discount{
                discountLabel.text = String(format: "%d", discount)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradientView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.15
        //   view.effect = UIBlurEffect(style: .dark)
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
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:22)
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:11)
        label.textColor = .LRLightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:14)
        label.isScrollEnabled = false
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor.LRBlue
        label.layer.borderColor = UIColor.LRBlue.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 2.5
        label.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //   view.effect = UIBlurEffect(style: .dark)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let discountLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:16)
        label.textColor = .LRRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountFormatter : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:8)
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
    
    func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10).isActive = true
        imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 15).isActive = true
        let size = UIScreen.main.bounds.height * 0.1
        imageView.heightAnchor.constraint(equalToConstant: size).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: size).isActive = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = size / 2
        imageView.layer.borderColor = UIColor.main.cgColor
        imageView.layer.borderWidth = 2
        
        imageView.addSubview(gradientView)
        gradientView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        
        viewContainer.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20).isActive = true
        
        viewContainer.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        
        /*
        viewContainer.addSubview(discountView)
        //    bottomView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.15).isActive = true
        discountView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20).isActive = true
        discountView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true
        discountView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.125).isActive = true
        discountView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.125).isActive = true
        
        discountView.addSubview(discountLabel)
        discountLabel.centerYAnchor.constraint(equalTo: discountView.centerYAnchor, constant: 0).isActive = true
        discountLabel.trailingAnchor.constraint(equalTo: discountView.centerXAnchor, constant: 5).isActive = true
        
        discountView.addSubview(discountFormatter)
        discountFormatter.centerYAnchor.constraint(equalTo: discountView.centerYAnchor, constant: 2.5).isActive = true
        discountFormatter.leadingAnchor.constraint(equalTo: discountLabel.trailingAnchor, constant: 1).isActive = true
        
        setupDiscountShadow() */

        
        //      layer.drawLine(fromPoint: CGPoint(x: 0, y: viewContainer.frame.minY), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: viewContainer.frame.minY))
        //       layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.175), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.175))
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
        shadowView.layer.shadowOpacity = 0.05
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
}
