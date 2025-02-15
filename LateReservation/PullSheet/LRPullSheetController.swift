//
//  FirstViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit
import CoreLocation

enum LRPullSheetPosition
{
    case full
    case horizontal
    case open
    case transitioning
    case hidden
}

protocol LRPullSheetDelegate
{
    func pullSheetPositionChanged(height: CGFloat, position: LRPullSheetPosition)
    func zoomToCurrentRestaurant(_ restaurant: Restaurant)
}

protocol LRSearchPositionDelegate
{
    func pullSheetEnteredFull(position: CGFloat)
    func pullSheetLeftFull(position: CGFloat)
}

class LRPullSheetController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var contentContainer: UIView!
    @IBOutlet var bgView: UIView!
    @IBOutlet var bgTopConstraint: NSLayoutConstraint!
    @IBOutlet var containerHeight: NSLayoutConstraint?
    @IBOutlet var gradientView: UIView!
    @IBOutlet var gradientTop: NSLayoutConstraint!
    
    var nearby = [Restaurant]()
    var laidoutShadow = false
    
    var parentVC : NearbyViewController?
    
    let fullViewOffset: CGFloat = 0
    var agentInfoHeight: CGFloat = 39
    var originalViewHeight:CGFloat = 0
    var tabBarHeight: CGFloat
    {
        return 66 * UIScreen.main.scale
    }
    let pullSheetOffset:CGFloat = 94
    var barsOffset : CGFloat = 0

    var currentChild: LRPullSheetChildController? = nil
    
    var delegate: LRPullSheetDelegate? = nil
    var positionDelegate: LRSearchPositionDelegate? = nil
    var cachedPosition: LRPullSheetPosition = .hidden
    
    var collectionHeight : NSLayoutConstraint?
    
  //  var originalHeight : CGFloat = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let tabbar = self.parentVC?.getTabBar()
        {
            let window = UIApplication.shared.keyWindow
            let topPadding:CGFloat = window?.safeAreaInsets.top ?? 0
            barsOffset = tabbar.frame.size.height + topPadding
        }
        
        originalViewHeight = self.view.frame.height
        
        let gesture = LRVerticalPanGesture.init(target: self, action: #selector(LRPullSheetController.panGesture))
        gesture.delegate = self as? UIGestureRecognizerDelegate
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        view.addGestureRecognizer(gesture)
        
        setupView()
        
        self.view.setNeedsDisplay()
        
        
        
        /*
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToTabs), name: SBNotifications.showTabs, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToCreate(_:)), name: SBNotifications.showCreate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShowNewListingNotification(_:)), name: SBNotifications.showNewListing, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(transitionToTabs), name: SBNotifications.newListingCreated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleForceBottomSheetCollapseNotification), name: SBNotifications.forceBottomSheetCollapse, object: nil) */
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

       changeSheetPosition(cachedPosition, animated: false)
    }
    
    let collectionView : UICollectionView = {
        let layout = FlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.decelerationRate = UIScrollViewDecelerationRateNormal
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.layer.masksToBounds = true
        return view
    }()

    func setupView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.register(LateTableCell.self, forCellWithReuseIdentifier: "nearbyCell")
        
        contentContainer.addSubview(collectionView)
        
        /*
        collectionView.topAnchor.constraint(equalTo: contentContainer.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: 0).isActive = true */

        collectionView.clipsToBounds = true
        
        /*
        contentContainer.layer.masksToBounds = true
        contentContainer.layer.cornerRadius = 5
        contentContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
 
        contentContainer.layoutIfNeeded() */
       // collectionView.layer.applySketchShadow(color: .black, alpha: 0.9, x: 0, y: 0, blur: 0.5, spread: 0.7)
        /*
        contentContainer.layer.masksToBounds = false
        contentContainer.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentContainer.layer.shadowRadius = 5
        contentContainer.layer.shadowOpacity = 0.6
        contentContainer.layer.shadowColor = UIColor.black.cgColor */

        
        self.gradientView.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.05).cgColor,
        UIColor.white.withAlphaComponent(1.0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.locations = [NSNumber(floatLiteral: 0.2), NSNumber(floatLiteral: 0.4), NSNumber(floatLiteral: 0.6), NSNumber(floatLiteral: 0.8), NSNumber(floatLiteral: 1.0)]
        gradientLayer.frame = self.gradientView.bounds
        
        self.gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupShadowView()
    {
        laidoutShadow = true
        let shadowView = UIView.init(frame: self.contentContainer.frame)
        shadowView.backgroundColor = .clear
        self.contentContainer.superview?.addSubview(shadowView)
        shadowView.addSubview(self.contentContainer)
        self.contentContainer.center = CGPoint(x: shadowView.frame.size.width / 2, y: shadowView.frame.size.height / 2)
        
        self.contentContainer.layer.masksToBounds = true
        shadowView.layer.masksToBounds = false
        
        self.contentContainer.layer.cornerRadius = 5
        self.contentContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowOpacity = 0.6
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.clipsToBounds = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        if !laidoutShadow
        {
            setupShadowView()
        }
       // originalHeight = (UIScreen.main.bounds.height)
        
        if self.collectionView.frame.height == 0
        {
            self.contentContainer.layoutIfNeeded()
            
            self.collectionView.frame = CGRect(x: 0, y: 0, width: self.contentContainer.frame.width, height: self.contentContainer.frame.height)
            self.collectionView.layoutIfNeeded()
            print("content container height \(self.contentContainer.frame.height)")
            print("collectionview height \(self.collectionView.frame.height)")
        }
    }
    
    func updateData(_ data : [Restaurant])
    {
        nearby = data        
        if nearby.count > 0
        {
            changeSheetPosition(.open)
            
            UIView.animate(withDuration: 0.2, animations: {
                if self.nearby.count > 1
                {
                    self.bgView.alpha = 0.05
                }
                else
                {
                    self.bgView.alpha = 1.00
                }
            })

        }
        else
        {
            changeSheetPosition(.hidden)
        }
        
        collectionView.reloadData()
    }

    
    @objc func handleForceBottomSheetCollapseNotification()
    {
        changeSheetPosition(.open)
    }
    
    func updateFrame(_ rect:CGRect, _ fromWhere:String)
    {
        self.view.frame = rect
        //UUDebugLog("updating frame (\(rect)) from: \(fromWhere)")
        
        cachedPosition = calculatePosition()
        //UUDebugLog("position: \(cachedPosition)")
        
        var availableHeight : CGFloat = 0
        let screenHeight = UIScreen.main.bounds.height
        if cachedPosition == .open
        {
            availableHeight = screenHeight - openOffset()
        }
        else if cachedPosition == .horizontal
        {
            availableHeight = screenHeight - horizontalOffset()
        }
        
        delegate?.pullSheetPositionChanged(height: availableHeight,position: cachedPosition)
        
        if cachedPosition == .full
        {
            positionDelegate?.pullSheetEnteredFull(position: rect.minY)
            UIView.animate(withDuration: 0.2, animations: {
                self.bgView.alpha = 1.00
                self.bgTopConstraint.constant = -40
            })
        }
        else
        {
            positionDelegate?.pullSheetLeftFull(position: rect.minY)
            UIView.animate(withDuration: 0.2, animations: {
                if self.nearby.count > 1 || self.cachedPosition == .horizontal
                {
                    self.bgView.alpha = 0.05
                }
                else
                {
                    self.bgView.alpha = 1.00
                }
                self.bgTopConstraint.constant = 40
            })
        }
        
        if (cachedPosition == .open || cachedPosition == .full)
        {
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                if layout.scrollDirection == .horizontal
                {
                    UIView.animate(withDuration: 0.1, animations: {
                        layout.scrollDirection = .vertical
                        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.contentContainer.frame.width, height: self.contentContainer.frame.height)
                   /*     self.collectionHeight?.isActive = false
                        self.collectionHeight = self.collectionView.heightAnchor.constraint(equalToConstant: self.contentContainer.frame.height)
                        self.collectionHeight?.isActive = true */
                        self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
                        self.collectionView.layoutIfNeeded()
                        print("content container height \(self.contentContainer.frame.height)")
                        print("collectionview height \(self.collectionView.frame.height)")
                      //  print(self.collectionView.contentSize.height)
                    })
                    
                    self.gradientTop.constant = 0
                }
            }
        }
        else if (cachedPosition == .horizontal)
        {
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                if layout.scrollDirection == .vertical
                {
                    UIView.animate(withDuration: 0.1, animations: {
                    /*    self.collectionHeight?.isActive = false
                        self.collectionHeight =
                        self.collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.38)
                        self.collectionHeight?.isActive = true */
                        layout.scrollDirection = .horizontal
                        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.contentContainer.frame.width, height: UIScreen.main.bounds.height * 0.3775)
                        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast
                        self.collectionView.layoutIfNeeded()
                        print("content container height \(self.contentContainer.frame.height)")
                        print("collectionview height \(self.collectionView.frame.height)")
                       // self.collectionView.reloadData()
                        self.zoomToPin(0)
                    })
                    
                    self.gradientTop.constant = 50
                }
            }
        }
    }
    
    private func calculatePosition() -> LRPullSheetPosition
    {
        let y = Int(view.frame.origin.y)
        
        if (y == 0)
        {
            return .full
        }
        else if (y == Int(horizontalOffset()))
        {
            return .horizontal
        }
        else if (y == Int(openOffset()))
        {
            return .open
        }
        else
        {
            return .transitioning
        }
    }
    
    private func changeSheetPosition(_ mode: LRPullSheetPosition, animated: Bool = true)
    {
        var offset : CGFloat = 0.0
        
        if (mode == .horizontal)
        {
            offset = horizontalOffset()
        }
        else if (mode == .open || mode == .full)
        {
            UIView.animate(withDuration: 0.0, animations: {
               // self.containerHeight?.constant = self.originalViewHeight - self.barsOffset
              //  self.contentContainer.layoutIfNeeded()
            })
            if mode == .open
            {
                offset = openOffset()
                self.collectionView.setContentOffset(CGPoint.zero, animated: true)
            }
            else
            {
                offset = listViewOffset()
            }
        }
        else if mode == .hidden
        {
            offset = hiddenOffset()
        }
        
        let rect = CGRect(x: 0, y: offset, width: view.frame.width, height: frameHeightForOffset(offset))
        
        if (animated)
        {
            UIView.animate(withDuration: 0.5, animations:
            {
                self.updateFrame(rect, "changePosition")
            })
        }
        else
        {
            updateFrame(rect, "changePosition")
        }
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer)
    {
        
        let translation:CGPoint = recognizer.translation(in: self.view)
        let velocity:CGPoint = recognizer.velocity(in: self.view)
        
        let y:CGFloat = self.view.frame.minY
        let offset:CGFloat = y + translation.y
        
        
        /**
         A Boolean value that controls whether the scroll view scroll should pan the parent view up **or** down.
         
         1. The user should be able to drag the view down through the internal scroll view when
         - the scroll direction is down (`isScrollingDown`)
         - the internal scroll view is scrolled to the top (`scrollView.contentOffset.y <= 0`)
         
         2. The user should be able to drag the view up through the internal scroll view when
         - the scroll direction is up (`!isScrollingDown`)
         - the PullUpController's view is fully opened. (`topConstraint.constant != parentViewHeight - lastStickyPoint`)
         */
        let shouldDragView: Bool = {
            // Condition 1
            let shouldDragViewDown = isDraggingDown(velocity) && collectionView.contentOffset.y <= 0
            // Condition 2
            let shouldDragViewUp = isDraggingUp(velocity) && cachedPosition != .full
            return shouldDragViewDown || shouldDragViewUp
        }()
        
        if recognizer.state == .changed
        {
            // the user is scrolling the internal scroll view
            if velocity.y != 0 {
                // if the user shouldn't be able to drag the view up through the internal scroll view reset the translation
                guard
                    shouldDragView
                    else {
                        recognizer.setTranslation(CGPoint.zero, in: self.view)
                        return
                }
                // disable the bounces when the user is able to drag the view through the internal scroll view
                collectionView.bounces = false
                if isDraggingDown(velocity) {
                    // take the initial internal scroll view content offset into account when scrolling down
                 //   yTranslation -= initialInternalScrollViewContentOffset.y
                //    initialInternalScrollViewContentOffset = .zero
                } else {
                    // keep the initial internal scroll view content offset when scrolling up
                    collectionView.contentOffset = .zero
                    if offset < horizontalOffset()
                    {
                        UIView.animate(withDuration: 0.1, animations: {
                        //    self.containerHeight?.constant = self.originalViewHeight - self.barsOffset
                            self.contentContainer.layoutIfNeeded()
                    //        print("collectionheight height: %d", self.collectionView.frame.height)
                    //        print("container height: %d", self.contentContainer.frame.height)
                        })
                    }
                }
                
                updateFrame(CGRect(x: 0, y: offset, width: view.frame.width, height: frameHeightForOffset(offset)), "panGesture")
                recognizer.setTranslation(CGPoint.zero, in: self.view)
            }
        }
        else if recognizer.state == .ended
        {
            
            guard
                shouldDragView
                else { return }
            
            updateFrame(CGRect(x: 0, y: offset, width: view.frame.width, height: frameHeightForOffset(offset)), "panGesture")
            recognizer.setTranslation(CGPoint.zero, in: self.view)
            
            let targetOffset:CGFloat = getTargetOffset(velocity, translation)
            var duration =  velocity.y < 0 ? Double((y - targetOffset) / -velocity.y) : Double((targetOffset - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            let targetFrameHeight:CGFloat = frameHeightForOffset(targetOffset)
            var animatingFrameHeight:CGFloat = targetFrameHeight
            
            if (isDraggingUp(velocity))
            {
                //if animating the view up, calculate the height and set that first, so you don't see it on screen
                updateFrame(CGRect(x: 0, y: y + translation.y, width: self.view.frame.width, height: targetFrameHeight), "panGuestureEnded")
            }
            else
            {
                //if going down, keep the current frame height until the animation is complete
                animatingFrameHeight = self.view.frame.height
            }

            animateSnapToOffset(duration, targetOffset, animatingFrameHeight, velocity, translation, targetFrameHeight)
        }
    }
    
    private func animateSnapToOffset(_ duration:Double, _ targetOffset:CGFloat, _ animatingFrameHeight: CGFloat, _ velocity:CGPoint, _ translation:CGPoint, _ targetFrameHeight:CGFloat)
    {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations:
            {
                self.updateFrame(CGRect(x: 0, y: targetOffset, width: self.view.frame.width, height: animatingFrameHeight), "animation")
        },completion:
            {
                _ in
                
                
                if ( self.isDraggingUp(velocity) )
                {
                    self.currentChild?.enableScrolling()
                }
                
                
                if (self.isDraggingDown(velocity))
                {
                    self.updateFrame(CGRect(x: 0, y: targetOffset, width: self.view.frame.width, height: targetFrameHeight), "animation ended dragging down")
                }
        })
    }
    
    private func isDraggingUp(_ velocity:CGPoint) -> Bool
    {
        return !isDraggingDown(velocity)
    }
    
    private func isDraggingDown(_ velocity:CGPoint) -> Bool
    {
        return (velocity.y >= 0)
    }
    
   
    
    /*
     figure out which direction and then determine which area the current frame is in
     1. above fullView
     target fullView
     2. between fullView and listView offsets
     if  dragging up, target fullView offset
     else target listView offset
     3. between listView and collapsedView offsets
     if dragging up, target listView offset
     else target collapsedView offset
     4. below full collapse
     target collapse
     */

    /*
    private func dragIsInZoneOne(_ translation:CGPoint) -> Bool
    {
        return (self.view.frame.minY + translation.y < fullViewOffset)
    }
    
    private func dragIsInZoneTwo(_ translation:CGPoint) -> Bool
    {
        let y:CGFloat = self.view.frame.minY
        return ((y + translation.y >= fullViewOffset) && (y + translation.y < listViewOffset()))
    }
    
    private func dragIsInZoneThree(_ translation:CGPoint) -> Bool
    {
        let y:CGFloat = self.view.frame.minY
        return ((y + translation.y >= listViewOffset()) && (y + translation.y < openOffset()))
    } */
    
    private func dragIsInZoneMid(_ translation:CGPoint) -> Bool
    {
        return ((self.view.frame.minY + translation.y) >= openOffset()) && ((self.view.frame.minY + translation.y) <= horizontalOffset())
    }
    
    private func dragIsInZoneLow(_ translation:CGPoint) -> Bool
    {
        return ((self.view.frame.minY + translation.y) >= horizontalOffset())
    }
    
    private func getTargetOffset(_ velocity:CGPoint, _ translation:CGPoint) -> CGFloat
    {
        var targetOffset:CGFloat = 0
        /*
        if (dragIsInZoneOne(translation))
        {
            targetOffset = fullViewOffset
            //UUDebugLog("zone 1 -> fullViewOffset")
        }
        else if (dragIsInZoneTwo(translation))
        {
            if (isDraggingDown(velocity))
            {
                targetOffset = listViewOffset()
                //UUDebugLog("zone 2 -> down -> listViewOffset")
            }
            else
            {
                targetOffset = fullViewOffset
                //UUDebugLog("zone 2 -> up  -> fullViewOffset")
            }
        }
        else */
        if (dragIsInZoneMid(translation))
        {
            targetOffset = openOffset()
            //UUDebugLog("zone 4 -> collapsedOffset")
        }
        else if (dragIsInZoneLow(translation))
        {
            targetOffset = horizontalOffset()
            //UUDebugLog("zone 4 -> collapsedOffset")
        }
        else
        {
            if (isDraggingDown(velocity))
            {
                targetOffset = openOffset()
                //UUDebugLog("zone 3 -> down -> collapsedOffset")
            }
            else
            {
                targetOffset = listViewOffset()
                //UUDebugLog("zone 3 -> up  -> listViewOffset")
            }
        }
        
        return targetOffset
    }

    private func frameHeightForOffset(_ offset:CGFloat) -> CGFloat
    {
        //need to put a niminum on this
        
        let offsetToUse:CGFloat = offset < listViewOffset() ? offset : listViewOffset()
        
        //let height:CGFloat = originalViewHeight - offset - (agentInfoHeight*2) - 20 - 8
        var statusBarAndSafeArea:CGFloat = 0

        let window = UIApplication.shared.keyWindow
        let topPadding:CGFloat = window?.safeAreaInsets.top ?? 0
        var bottomPadding = window?.safeAreaInsets.bottom
        //UUDebugLog("\n\n\ntopPadding = \(topPadding)\nbottomPadding = \(bottomPadding)\n\n\n")
        
        if (topPadding > 0)
        {
            statusBarAndSafeArea = topPadding
        }
        else
        {
            statusBarAndSafeArea = 28
        }
        
        var tabbarHeight : CGFloat = 0

        let height:CGFloat = originalViewHeight - statusBarAndSafeArea
        
        print("view height \(height)")
        
        let finalHeight = height //< min ? min : height
        
       // UUDebugLog("\n\n\nframeHeightForOffset: offset: \(offset)\nreturned height: \(finalHeight)\noriginalHeight: \(originalViewHeight)\noffsetToUse: \(offsetToUse)\nagentHeightToUse: \(agentHeightToUse)\nstatusBarAndSafeArea: \(statusBarAndSafeArea)")
        
        return finalHeight
    }
    
    private func openOffset() -> CGFloat
    {
        let offset:CGFloat = UIScreen.main.bounds.height * 0.275 //- 94//(66 * 2)
        //UUDebugLog("\n\ncollapsed offset: \(offset)\noriginal \(originalViewHeight)\nagentInfo \(agentInfoHeight)\ntabBarHeight \(tabBarHeight)")
        return offset
    }
    
    private func listViewOffset() -> CGFloat
    {
        let offset:CGFloat = 0
        return offset
    }
    
    private func hiddenOffset() -> CGFloat
    {
        return UIScreen.main.bounds.height
    }
    
    private func horizontalOffset() -> CGFloat
    {
        if let tabbar = self.parentVC?.getTabBar()
        {
            var statusBarAndSafeArea:CGFloat = 0
            
            let window = UIApplication.shared.keyWindow
            let topPadding:CGFloat = window?.safeAreaInsets.top ?? 0
            var bottomPadding = window?.safeAreaInsets.bottom ?? 0
            //UUDebugLog("\n\n\ntopPadding = \(topPadding)\nbottomPadding = \(bottomPadding)\n\n\n")
            
            if (topPadding > 0)
            {
                statusBarAndSafeArea = topPadding
            }
            else
            {
                statusBarAndSafeArea = 28
            }
            
            let cellHeight = UIScreen.main.bounds.height * 0.375
            let shadowHeight : CGFloat = 26
            //don't use all the bottom padding -- otherwise there's a more noticable gap on x+ devices
            let bottom : CGFloat = bottomPadding * 0.75
            
            //10 just for a little extra spacing
            let offset = (tabbar.frame.minY - cellHeight - bottom - shadowHeight) - 5
            return offset
        }
        
        let offset:CGFloat = UIScreen.main.bounds.height * 0.47
        print("offset \(offset)")
        return offset
    }
    
    //collectionview
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let rest = nearby[indexPath.row]
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToRestProfile(rest: rest)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return nearby.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearbyCell", for: indexPath) as! LateTableCell
        let restaurant = nearby[indexPath.row]
        cell.card = restaurant
        
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        
        if Favorites.isFavorited(id: restaurant.id)
        {
            cell.likeImg.image = #imageLiteral(resourceName: "like_active")
        }
        else
        {
            cell.likeImg.image = #imageLiteral(resourceName: "like_img")
        }
        cell.likeButton.isHidden = false
        cell.likeImg.isHidden = false
        
        let city = LRParser.getCity(restaurant)
        
        if let lastLocation = Defaults.getLastLocation()
        {
            let restaurantLocation = CLLocation(latitude: restaurant.lat, longitude: restaurant.lon)
            //String(format: "%@  •  %.1f mi", city, LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation))
            let locationText = city
            cell.locationLabel.text = locationText
            cell.distanceLabel.text = String(format: "%.1f mi", LRLocationManager.distanceBetween(userLocation: lastLocation, restaurantLocation: restaurantLocation))
        }
        else
        {
            cell.locationLabel.text = city
        }
        
        if restaurant.reservations.count > 0
        {
            let tables = restaurant.reservations
            cell.discountLabel.text = String(format: "%d%% Off", tables[0].discount)
            cell.timeLabel.font = UIFont(name:"SourceSansPro-Regular",size:13)
            cell.discountView.isHidden = false
            cell.emptyView.isHidden = true
            
            /*
             cell.timesView.containerType = ContainerType.nearby
             cell.timesView.tables?.removeAll()
             cell.timesView.tables = restaurant.reservations
             cell.timesView.collectionView.reloadData()
             */
            
            cell.timeLabel.text = String(format: "Available + %d More", tables.count)
            
        }
        else
        {
            cell.timeLabel.text = "Nothing Listed Right Now"
            cell.discountView.isHidden = true
            cell.timeLabel.font = UIFont(name:"SourceSansPro-Regular",size:13)
            cell.emptyView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            if layout.scrollDirection == .horizontal
            {
                return CGSize(width: UIScreen.main.bounds.width * 0.85, height: UIScreen.main.bounds.height * 0.375)
            }
        }

        return CGSize(width: collectionView.frame.width, height: UIScreen.main.bounds.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            if layout.scrollDirection == .horizontal
            {
                return 10
            }
        }
        
        return 5
    }
    
    @objc func likeTapped(_ sender: UIButton) {
        
        if Defaults.isLoggedIn()
        {
            let indexPath = IndexPath.init(row: sender.tag, section: 0)
            let rest = nearby[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! LateTableCell
            if Favorites.isFavorited(id: rest.id)
            {
                print("unliking")
                cell.likeImg.image = #imageLiteral(resourceName: "like_img")
                if let favId = Favorites.getFavoritedId(id: rest.id)
                {
                    LRServer.shared.deleteFavorite(favId, completion: {
                        DispatchQueue.main.async {
                            self.updateTabVC()
                        }
                    })
                }
            }
            else
            {
                print("liking")
                cell.likeImg.image = #imageLiteral(resourceName: "like_active")
                AppDelegate.shared().registerForPushNotifications()
                LRServer.shared.addFavorite(rest, completion: {
                    DispatchQueue.main.async {
                        self.updateTabVC()
                    }
                })
            }
        }
        else
        {
            if let tabBar: TabBarController = self.tabBarController as? TabBarController
            {
                tabBar.goToLogin()
            }
        }
    }
    
    func updateTabVC()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.updateFavorites()
        }
    }
    
    func mapPinTapped(_ restaurant : Restaurant)
    {
        changeSheetPosition(.horizontal, animated: true)
        let indexPath = IndexPath(item: getRestaurantIndex(restaurant), section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: [.centeredVertically, .left], animated: true)
    }
    
    func getRestaurantIndex(_ restaurant : Restaurant) -> Int
    {
        var index = 0
        
        for rest in nearby
        {
            if rest.id == restaurant.id
            {
                break
            }
            
            index += 1
        }
        
        
        return index
    }
}

extension LRPullSheetController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension LRPullSheetController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView {
            if cachedPosition == .full
            {
                
                if collectionView.contentOffset.y == 0
                {
                    if collectionView.panGestureRecognizer.translation(in: collectionView.superview).y > 0 {
                        changeSheetPosition(.open, animated: true)
                    }
                    
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if scrollView.contentOffset.y <= 0
        {
            //collectionView.isScrollEnabled = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        {
            if layout.scrollDirection == .horizontal
            {
                var zoomRow : Int = 0
                var currLow = 10000
                for cell in collectionView.visibleCells as! [LateTableCell]
                {
                    let center = collectionView.convert(cell.frame, to: self.view)
                    let indexPath = collectionView.indexPath(for: cell)!
                    if center.minX < CGFloat(currLow) && center.minX > 0
                    {
                        zoomRow = indexPath.row
                        currLow = Int(center.minX)
                    }
                }
                
                zoomToPin(zoomRow)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {

    }
    
    func zoomToPin(_ row : Int)
    {
        if nearby.count > row
        {
            let restaurant = nearby[row]
            delegate?.zoomToCurrentRestaurant(restaurant)
        }
    }
    
    
}

/*
extension LRPullSheetController: LateTableCellDelegate
{
    
    func cellTapped(listing: LateTable)
    {
        self.transitionToDetail(listing: listing, forceScrollToRating: false)
    }
} */


