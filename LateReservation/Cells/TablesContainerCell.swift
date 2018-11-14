//
//  TablesContainerCell.swift
//  LateOwner
//
//  Created by Neil Ballard on 10/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit


enum ContainerType
{
    case nearby
    case detail
}

class TablesContainerView : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    var tables : [LateReservation]?
    var containerType : ContainerType = ContainerType.nearby
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    func updateData()
    {
        collectionView.reloadData()
    }

    func setupView(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = true
        collectionView.register(TablesCollectionCell.self, forCellWithReuseIdentifier: "tableCell")

        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     /////
     /// CollectionView Implementation
     /////
     */
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*
         let cell = collectionView.cellForItem(at: indexPath) as! ActiveTableCell
         
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if let tables = self.tables
        {        
            return tables.count
        }
        
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableCell", for: indexPath) as! TablesCollectionCell
        
        if let tables = self.tables
        {
            let table = tables[indexPath.row]
            
            if let resTime = table.reservationTime
            {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                formatter.timeZone = TimeZone.current
                let dateString = formatter.string(from: resTime)
                cell.slot.text = dateString
                //cell.slot.backgroundColor = .LRBlue
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width * 0.29, height: UIScreen.main.bounds.height * 0.045)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
