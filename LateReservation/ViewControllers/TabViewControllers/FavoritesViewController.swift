//
//  SecondViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var favorites = [Favorite]()

    
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
        imageView.image = #imageLiteral(resourceName: "empty_favorites")
        imageView.isHidden = true
        return imageView
    }()
    
    let emptyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:18)
        label.textColor = UIColor.header
        label.textAlignment = .center
        label.isHidden = true
        label.text = "No Favorites"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        

    NotificationCenter.default.addObserver(self, selector: #selector(getData), name: .favoritesDidChange, object: nil)
        setupView()
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func getData()
    {
        if Defaults.isLoggedIn()
        {
            LRServer.shared.getFavorites() {
                (favorites: [Favorite]?, error: Error?) in
                DispatchQueue.main.async {
                    if let list = favorites
                    {
                        self.favorites = list
                        self.collectionView.reloadData()
                        
                        if self.favorites.count > 0
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: "favoriteCell")
        collectionView.register(FavoriteHeaderCell.self, forSupplementaryViewOfKind:
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
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let rest = favorites[indexPath.row]
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToRestProfile(rest: rest)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return favorites.count
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as! FavoriteCell
        
        let row = indexPath.row
        cell.card = favorites[row]
     //   cell.discountLabel.isHidden = true
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.width * 0.27
        let height = UIScreen.main.bounds.height * 0.225
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:
        String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:
            "header", for: indexPath) as! FavoriteHeaderCell
        
        header.headerLabel.text = "Favorites"
        header.descLabel.text = "Get notified for exclusive tables"
        
        return header
    }

}

