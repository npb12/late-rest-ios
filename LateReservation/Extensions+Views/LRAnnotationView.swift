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

class LRAnnotationView: MKAnnotationView {
    
    private let annotationFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    var label: UILabel

    // data
  //  weak var personDetailDelegate: PersonDetailMapViewDelegate?
 //   weak var customCalloutView: PersonDetailMapView?
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
    /*
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // This is important: Don't show default callout.
        //self.image = kPersonMapPinImage
    } */
    
    // MARK: - callout showing and hiding
    // Important: the selected state of the annotation view controls when the
    // view must be shown or not. We should show it when selected and hide it
    // when de-selected.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        /*
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
            }
        } */
    }
    
    /*
    func loadPersonDetailMapView() -> PersonDetailMapView? {
        if let views = Bundle.main.loadNibNamed("PersonDetailMapView", owner: self, options: nil) as? [PersonDetailMapView], views.count > 0 {
            let personDetailMapView = views.first!
            personDetailMapView.delegate = self.personDetailDelegate
            if let personAnnotation = annotation as? PersonWishListAnnotation {
                let person = personAnnotation.person
                personDetailMapView.configureWithPerson(person: person)
            }
            return personDetailMapView
        }
        return nil
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    // MARK: - Detecting and reaction to taps on custom callout.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    } */
}
