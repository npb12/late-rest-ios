//
//  LRMapController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import MapKit

protocol LRMapControllerDelegate
{
    func mapPinTapped(listing:Restaurant)
}

class LRMapController: UIViewController, MKMapViewDelegate, LRPullSheetDelegate
{
    
    @IBOutlet var mapView: MKMapView!
    
    private var mapData: [Restaurant] = []
    private var visibleRect: CGRect? = nil
    private var pullSheetPosition: LRPullSheetPosition = .open
    private var focusedAnnotationCoordinate : CLLocationCoordinate2D? = nil
    
    var delegate:LRMapControllerDelegate? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.showsUserLocation = false
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        
        /*
         NotificationCenter.default.addObserver(self, selector: #selector(refreshMapPins), name: SBNotifications.refreshMapPins, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(refreshSingleMapPin(_:)), name: SBNotifications.refreshListing, object: nil) */
    }
    
    func centerOnUserLocation()
    {
        safeCenterMapOnLocation(mapView.userLocation.coordinate)
    }
    
    
    func pullSheetPositionChanged(height: CGFloat, position: LRPullSheetPosition)
    {
        pullSheetPosition = position
        
        var r = self.view.frame
        r.size.height = (UIScreen.main.bounds.size.height - height) + 70
        visibleRect = r
        
        if position != .horizontal
        {
            
            let annotations = mapView.selectedAnnotations
            
            for selected in annotations
            {
                mapView.deselectAnnotation(selected, animated: false)
            }            
        }
    }
    
    
    private func safeCenterMapOnLocation(_ coordinate:CLLocationCoordinate2D)
    {
        if (visibleRect != nil)
        {
            var visibleRegion:MKCoordinateRegion = mapView.convert(visibleRect!, toRegionFrom: view)
            
            let latDiff = mapView.centerCoordinate.latitude - visibleRegion.center.latitude

            //
            // visibleRect is the visible area of the map view above the pull up
            // drawer
            //
            // region.center is the mapview point that is centered in the visible
            // portion of the map above the pull up drawer
            //
            // currentCenter is the current center point of the map view
            //
            // What we need to do is make currentCenter lat/lng point be centered
            // on the center point of visibleRect
            //
            
            var adjustedCenter = coordinate
            adjustedCenter.latitude += latDiff
            
            if (CLLocationCoordinate2DIsValid(adjustedCenter))
            {
                visibleRegion.center = adjustedCenter
                
                mapView.setRegion(visibleRegion, animated: true)
            }
        }
    }
    
    func zoomToCurrentRestaurant(_ restaurant: Restaurant)
    {
        let coord = CLLocationCoordinate2D(latitude: restaurant.lat, longitude: restaurant.lon)
        safeCenterMapOnLocation(coord)
    }
    
    public func zoomToAll(animated: Bool, center: CLLocationCoordinate2D? = nil)
    {
        
    }
    
    public func zoomToAnnotations(animated: Bool, center: CLLocationCoordinate2D? = nil)
    {
        
         if (visibleRect == nil)
         {
         mapView.uuZoomToAnnotations(animated: true, center: center)
         return
         }
         
         var boundingRegion = MKMapView.uuFindBoundingBox(annotations: mapView.annotations)
         if (boundingRegion != nil)
         {
         if (center != nil && CLLocationCoordinate2DIsValid(center!))
         {
         boundingRegion!.center.latitude = center!.latitude
         boundingRegion!.center.longitude = center!.longitude
         }
         
         let oldRegion = mapView.region
         mapView.setRegion(boundingRegion!, animated: false)
         
         
         let visibleRegion = mapView.convert(visibleRect!, toRegionFrom: view)
         
         let latDiff = mapView.centerCoordinate.latitude - visibleRegion.center.latitude
         
         mapView.setRegion(oldRegion, animated: false)
         
         //
         // visibleRect is the visible area of the map view above the pull up
         // drawer
         //
         // region.center is the mapview point that is centered in the visible
         // portion of the map above the pull up drawer
         //
         // currentCenter is the current center point of the map view
         //
         // What we need to do is make currentCenter lat/lng point be centered
         // on the center point of visibleRect
         //
         
         var adjustedCenter = boundingRegion!.center
         adjustedCenter.latitude += latDiff
         
         if (CLLocationCoordinate2DIsValid(adjustedCenter))
         {
         boundingRegion!.center = adjustedCenter
         
         let adjustedRegion = mapView.regionThatFits(boundingRegion!)
         mapView.setRegion(adjustedRegion, animated: animated)
         }
         }
    }
    
    
    @objc public func refreshSingleMapPin(_ notification: Notification)
    {
        /*
         let rawListing = notification.userInfo?["listing"] as? LRListing
         
         if let listing = rawListing
         {
         var center : CLLocationCoordinate2D? = nil
         
         for annotation in mapView.annotations
         {
         let lrAnnotation = annotation as? SBListingAnnotation
         
         if let myAnnotation = lrAnnotation
         {
         if (myAnnotation.listing.identifier == listing.identifier)
         {
         mapView.removeAnnotation(annotation)
         
         let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: listing.latitude, longitude: listing.longitude)
         if (CLLocationCoordinate2DIsValid(coord))
         {
         let annotation = SBListingAnnotation(listing: listing)
         mapView.addAnnotation(annotation)
         
         if (center == nil)
         {
         center = annotation.coordinate
         }
         }
         
         break
         }
         }
         }
         
         zoomToAnnotations(animated: true, center: center)
         } */
    }
    
    
    public func refreshMapPins(_ data : [Restaurant])
    {
        let tables : [Restaurant]? = data//sender.object as? [LateTable]
        if (tables != nil)
        {
            //UUDebugLog("refresh map pins")
            mapData = tables!
            refreshMapAnnotations()
        }
    }
    
    private func refreshMapAnnotations()
    {
         // Clear all existing annotations
         mapView.removeAnnotations(mapView.annotations)
         
         var center : CLLocationCoordinate2D? = nil
         
         for rest in mapData
         {
            let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lon)
            if (CLLocationCoordinate2DIsValid(coord))
            {
                let annotation = LRRestAnnotation(rest: rest)
                mapView.addAnnotation(annotation)
                
                if (center == nil)
                {
                    center = annotation.coordinate
                }
            }
            else
            {
                //UUDebugLog("Invalid location for listing: \(listing)")
            }
         }
        
       zoomToAnnotations(animated: true, center: center)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        let annotation = view.annotation as? LRRestAnnotation
        if let myAnnotation = annotation
        {
            //view.image = UIImage(named: myAnnotation.listing.pinImageName(true))
            //view.centerOffset = CGPoint(x: 0, y: -(view.image!.size.height / 2))
            if let rest = myAnnotation.rest
            {
                delegate?.mapPinTapped(listing: rest)
                let location = CLLocation(latitude: rest.lat, longitude: rest.lon)
                safeCenterMapOnLocation(location.coordinate)
            }
        }
        
        
        /*
         let annotation = view.annotation as? SBListingAnnotation
         
         if let myAnnotation = annotation
         {
         view.image = UIImage(named: myAnnotation.listing.pinImageName(true))
         view.centerOffset = CGPoint(x: 0, y: -(view.image!.size.height / 2))
         delegate?.mapPinTapped(listing: myAnnotation.listing)
         } */
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        
        
        /*
         let annotation = view.annotation as? SBListingAnnotation
         if (annotation != nil)
         {
         view.image = UIImage(named: annotation!.listing.pinImageName(false))
         view.centerOffset = CGPoint(x: 0, y: -(view.image!.size.height / 2))
         } */
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation)
    {
        if (mapData.count == 0)
        {
            safeCenterMapOnLocation(mapView.userLocation.coordinate)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {

        if annotation is LRRestAnnotation
        {
            let lrAnnotation = annotation as! LRRestAnnotation

            let annotationView = LRAnnotationView(annotation: annotation, reuseIdentifier: "pin") as LRAnnotationView
            
           // annotationView.markerTintColor = UIColor.mapColor
            
            if lrAnnotation.rest.reservations.count > 0
            {
                var high = 0
                for reservation in lrAnnotation.rest.reservations
                {
                    if reservation.discount > high
                    {
                        high = reservation.discount
                    }
                }
                
                if high > 0
                {
                    annotationView.image = mapPinImage
                    annotationView.label.isHidden = false
                    annotationView.label.text = String(format: "%d%%", high)
                }
                else
                {
                    annotationView.image = mapNoDiscountImage
                    annotationView.label.isHidden = true
                }
            }
            else
            {
                annotationView.image = mapNoDiscountImage
                annotationView.label.isHidden = true
            }
            
            return annotationView
        }
        
        return  nil
        
        
        /*
        if annotation is SBListingAnnotation
         {
         let sbAnnotation = annotation as! SBListingAnnotation
         let reuseId = "SBListingAnnotationViewId"
         var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
         
         if (pinView == nil)
         {
         pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
         pinView?.isEnabled = true
         pinView?.canShowCallout = true
         }
         else
         {
         pinView?.annotation = annotation
         }
         
         pinView!.image = UIImage(named: sbAnnotation.listing.pinImageName(false))
         pinView!.centerOffset = CGPoint(x: 0, y: -(pinView!.image!.size.height / 2))
         
         let rejected:Bool = sbAnnotation.listing.userData?.isRejected ?? false
         
         if (rejected)
         {
         pinView?.alpha = 0.7
         }
         else
         {
         pinView?.alpha = 1.0
         }
         
         return pinView
         }
 
        return nil */
    }
}

 class LRRestAnnotation : NSObject, MKAnnotation
 {
 var rest: Restaurant!
 
 required init(rest: Restaurant)
 {
 super.init()
 self.rest = rest
 }
 
 var coordinate: CLLocationCoordinate2D
 {
 return CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lon)
 }
 
 public var title: String?
 {
    /*
    let name:String = rest.restaurantName
    var discVal = 0
    if rest.reservations.count > 0
    {
        discVal = rest.reservations[0].discount
    }
    
    if discVal > 0
    {
        return String(format: "%@\n%d%% Off", name, discVal)
    } */
 
    return ""
 }

 }

extension Restaurant
{   /*
     func pinImageName(_ selected: Bool) -> String
     {
     var name : String = "blank"
     
     if (userData != nil)
     {
     if (userData!.isRejected)
     {
     name = "rejected"
     }
     else if (userData!.isFavorite)
     {
     name = "saved"
     }
     }
     
     name = "\(name)Pin"
     
     if (selected)
     {
     name = "\(name)Selected"
     }
     
     return name
     } */
}
