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
                formatter.dateFormat = "MMMM dd 'at' h:mm a"
                formatter.timeZone = TimeZone.current
                let dateString = formatter.string(from: time)
                timeLabel.text = String(format: "%@", dateString)
                //timeLabel.text = String(format: "Today, %@", dateString)

                if Calendar.current.isDateInToday(time) || time > Date()
                {
                    isExpired = false
                }
                else
                {
                    isExpired = true
                }
            }
            
            if let location = reservation?.restaurant?.location {
                locationLabel.text = location
            }
            
            if let discount = reservation?.discount{
                discountLabel.text = String(format: "%d%% Off", discount)
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
        label.font = UIFont(name:"Helvetica-Bold",size:20)
        label.textColor = UIColor.title
        label.text = "Title"
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
        label.font = UIFont(name:"Helvetica",size:14)
        label.textColor = .LLGreen//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.text = "Description"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let discountLabel : UITextView = {
        let label = UITextView()
        label.font = UIFont(name:"Helvetica-Bold",size:12)
        label.textColor = .subheader//UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
        label.backgroundColor = .main
        label.isScrollEnabled = false
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        //   label.layer.borderColor = UIColor.lightGray.cgColor
        //   label.layer.borderWidth = 0.75
        label.layer.cornerRadius = 2
        label.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 10).isActive = true
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
        titleLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -5).isActive = true
        
        viewContainer.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2.5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(discountLabel)
        discountLabel.bottomAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
        discountLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -10).isActive = true
        
        //      layer.drawLine(fromPoint: CGPoint(x: 0, y: viewContainer.frame.minY), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: viewContainer.frame.minY))
        //       layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.175), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.175))
    }
    
}
