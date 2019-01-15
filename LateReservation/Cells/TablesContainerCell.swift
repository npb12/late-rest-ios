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
    var tables = [String]()
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
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:13)
        label.textAlignment = .left
        label.textColor = UIColor.subheader
        label.text = "Nothing listed right now"
        label.numberOfLines = 1
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        addSubview(emptyLabel)
        emptyLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        emptyLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
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
        return tables.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tableCell", for: indexPath) as! TablesCollectionCell
        
        cell.slot.text = tables[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.height * 0.045)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7.5
    }
}
