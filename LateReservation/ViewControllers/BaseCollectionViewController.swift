//
//  BaseCollectionViewController.swift
//  Hank
//
//  Created by Neil Ballard on 11/6/18.
//  Copyright © 2018 Socal Labs LLC. All rights reserved.
//

import UIKit


class BaseCollectionViewController : UICollectionViewController {
    
    let loadingIndicator : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.activityIndicatorViewStyle = .whiteLarge
        view.color = .white
        view.isHidden = true
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let checkImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "checkmark")
        return imageView
    }()
    
    
    let modeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loadingView : UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    let divView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loadingLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SourceSansPro-SemiBold", size: 18)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView()
    {
        view.addSubview(loadingView)
        //   loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        //    loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        // loadingView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.6).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        //  loadingView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.45).isActive = true
        //   loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        //   loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        loadingView.addSubview(divView)
        divView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor).isActive = true
        divView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        
        loadingView.addSubview(loadingIndicator)
        loadingIndicator.bottomAnchor.constraint(equalTo: divView.topAnchor, constant: -5).isActive = true
        loadingIndicator.topAnchor.constraint(equalTo: loadingView.topAnchor, constant: 20).isActive = true
        
        loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        
        
        loadingView.addSubview(loadingLabel)
        loadingLabel.topAnchor.constraint(equalTo: divView.bottomAnchor, constant: 10).isActive = true
        loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 20).isActive = true
        loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -20).isActive = true
        loadingLabel.bottomAnchor.constraint(equalTo: loadingView.bottomAnchor, constant: -20).isActive = true
        
        loadingView.addSubview(checkImageView)
        checkImageView.bottomAnchor.constraint(equalTo: divView.topAnchor, constant: -5).isActive = true
        checkImageView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
    }
    
    func showIndicator(_ message : String, _ duration : Double, completion: @escaping (() -> Void))
    {
        self.loadingView.isHidden = false
        self.loadingIndicator.isHidden = false
        self.checkImageView.isHidden = true
        self.loadingLabel.text = message
        self.view.bringSubview(toFront: self.loadingView)
        self.loadingIndicator.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            completion()
        }
    }
    
    func hideIndicator()
    {
        self.loadingIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
    func showResult(_ message : String, _ success : Bool,  completion: @escaping () -> Void)
    {
        checkImageView.image = #imageLiteral(resourceName: "checkmark")
        loadingView.isHidden = false
        loadingIndicator.isHidden = true
        checkImageView.isHidden = false
        loadingLabel.text = message
        view.bringSubview(toFront: loadingView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion()
        }
    }
}
