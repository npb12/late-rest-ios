//
//  LRAnnotationView.swift
//  LateReservation
//
//  Created by Neil Ballard on 11/18/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import MapKit

public let mapPinImage = UIImage(named: "annotation_closed")!
public let mapNoDiscountImage = UIImage(named: "annotation_no_discount")!
private let kRestaurantMapAnimationTime = 0.300

class LRAnnotationView: MKAnnotationView {
    
    private let annotationFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    var label: UILabel

    // data
    weak var restaurantDetailDelegate: RestaurantDetailMapViewDelegate?
    weak var customCalloutView: LRCalloutView?
    override var annotation: MKAnnotation? {
        willSet {
            //customCalloutView?.removeFromSuperview()
        }
    }
    
    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        self.label = UILabel(frame: annotationFrame.offsetBy(dx: 0, dy: -6))
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false
        self.image = mapNoDiscountImage
        self.frame = self.frame
        self.label.font = UIFont(name:"SourceSansPro-Regular",size:14)
        self.label.textColor = .white
        self.label.text = "15%"
        self.label.isHidden = true
        self.label.textAlignment = .center
        self.backgroundColor = .clear
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented!")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadDistanceView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                self.label.font = UIFont(name:"SourceSansPro-Bold",size:14)
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kRestaurantMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kRestaurantMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                        self.label.font = UIFont(name:"SourceSansPro-Regular",size:14)
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        }
    }
    
    func loadDistanceView() -> LRCalloutView? {
        if let views = Bundle.main.loadNibNamed("LRCalloutView", owner: self, options: nil) as? [LRCalloutView], views.count > 0 {
            let restaurantDetailMapView = views.first!
            restaurantDetailMapView.delegate = self.restaurantDetailDelegate
            if let restaurantAnnotation = annotation as? LRRestAnnotation {
                if let person = restaurantAnnotation.rest
                {
                    restaurantDetailMapView.setRestaurant(person)
                }
            }
            return restaurantDetailMapView
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
