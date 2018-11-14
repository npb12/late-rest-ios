//
//  ReservationsViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class ReservationsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var reservations = [LateReservation]()
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let catSlider = UICollectionView(frame: .zero, collectionViewLayout: layout)
        catSlider.translatesAutoresizingMaskIntoConstraints = false
        catSlider.backgroundColor = UIColor.clear
        catSlider.showsVerticalScrollIndicator = false
        catSlider.isPagingEnabled = false
        return catSlider
    }()
    
    let emptyImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "empty_reservations")
        imageView.isHidden = true
        return imageView
    }()
    
    let emptyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:18)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.isHidden = true
        label.text = "No Reservations"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    @objc func infoTapped() {
        // let infoVC = InfoView()
        //  infoVC.modalPresentationStyle = .overCurrentContext
        //  present(infoVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Favorites"
        setupView()
        
    //    if Defaults.isLoggedIn()
     //   {
            getData()
    //    }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.contentSize.height = collectionView.contentSize.height + 20
        collectionView.layoutIfNeeded()
    }
    
    public func reservationSuccess()
    {
       showResult("Reservation Confirmed", true, completion: {
        self.hideIndicator()
       })
    }
    
    public func getData()
    {
        if Defaults.isLoggedIn()
        {
            LRServer.shared.getMyReservations() {
                (reservations: [LateReservation]?, error: Error?) in
                DispatchQueue.main.async {
                    if let list = reservations
                    {
                        self.reservations = list
                        self.collectionView.reloadData()
                        
                        if self.reservations.count > 0
                        {
                            self.emptyLabel.isHidden = true
                            self.emptyImageView.isHidden = true
                        }
                        else
                        {
                            self.emptyLabel.isHidden = false
                            self.emptyImageView.isHidden = false
                        }
                        /*
                         if list.count > 0
                         {
                         self.createButton.isHidden = true
                         self.emptyLabel.isHidden = true
                         }
                         else
                         {
                         self.createButton.isHidden = true
                         self.emptyLabel.isHidden = false
                         self.emptyLabel.text = "You haven't liked anything yet!"
                         }
                         let count = Favorites.dataCount()
                         self.favorites = list
                         self.collectionView.reloadData() */
                    }
                }
            }
        }

    }
    
    func setupView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(MyReservationsCell.self, forCellWithReuseIdentifier: "reservationCell")
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind:
            UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        emptyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(emptyImageView)
        emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyImageView.bottomAnchor.constraint(equalTo: emptyLabel.topAnchor, constant: -15).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyReservationsCell
        
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            if cell.isExpired
            {
                if let restaurant = reservations[indexPath.row].restaurant
                {
                    tabBar.goToRestProfile(rest: restaurant)
                }
            }
            else
            {
                let reservation = reservations[indexPath.row]
                tabBar.goToReservation(reservation)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return reservations.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 110)
    }
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
     return CGSize(width: UIScreen.main.bounds.width, height: 70)
     } */
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reservationCell", for: indexPath) as! MyReservationsCell
        
        let row = indexPath.row
        let reservation = reservations[row]
        cell.reservation = reservation

        
        if cell.isExpired
        {
            cell.alpha = 0.3
            cell.discountLabel.isHidden = true
            cell.timeLabel.textColor = .LLGray
        }
        else
        {
            cell.discountLabel.isHidden = false
            cell.alpha = 1.0
            cell.timeLabel.textColor = .LRBlue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = UIScreen.main.bounds.height * 0.175
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "header", for: indexPath) as! CollectionHeader
        
        header.headerLabel.text = "Reservations"
        header.descLabel.text = "Booked by you"
        
        return header
    }
    /*
    func updateTabVC()
    {
        if let tabBar: LLTabBarViewController = self.tabBarController as? LLTabBarViewController
        {
            tabBar.updateHome()
        }
    } */
}
