//
//  ChangePasswordViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/30/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit

class ChangePasswordViewController : BaseViewController
{
    let passContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subheader
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:15)
        label.text = "Password"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let confirmContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let confirmLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subheader
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:15)
        label.text = "Confirm Passowrd"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save Changes", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.LRRed, for: .normal)
        button.titleLabel?.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let passField : UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.isSecureTextEntry = true
        field.font = UIFont(name:"SourceSansPro-Regular",size:18)//UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        field.textColor = UIColor.header
        field.tag = 0
        field.attributedPlaceholder = NSAttributedString(string: "password",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let confirmField : UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.isSecureTextEntry = true
        field.font = UIFont(name:"SourceSansPro-Regular",size:18)//UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        field.textColor = UIColor.header
        field.tag = 0
        field.attributedPlaceholder = NSAttributedString(string: "password",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .main
        setupViews()
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
    }
    
    func setupViews() {
        
        
        view.addSubview(passLabel)
        passLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        passLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        
        view.addSubview(passContainer)
        passContainer.topAnchor.constraint(equalTo: passLabel.bottomAnchor, constant: 10).isActive = true
        passContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        passContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        passContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        
        passContainer.layoutIfNeeded()
        
        passContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        passContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.09), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.09))
        
        
        passContainer.addSubview(passField)
        passField.topAnchor.constraint(equalTo: passContainer.topAnchor, constant: 0).isActive = true
        passField.bottomAnchor.constraint(equalTo: passContainer.bottomAnchor, constant: 0).isActive = true
        passField.leadingAnchor.constraint(equalTo: passContainer.leadingAnchor, constant: 20).isActive = true
        passField.trailingAnchor.constraint(equalTo: passContainer.trailingAnchor, constant: -20).isActive = true
        
        
        
        view.addSubview(confirmLabel)
        confirmLabel.topAnchor.constraint(equalTo: passContainer.bottomAnchor, constant: 25).isActive = true
        confirmLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        
        
        view.addSubview(confirmContainer)
        confirmContainer.topAnchor.constraint(equalTo: confirmLabel.bottomAnchor, constant: 10).isActive = true
        confirmContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        confirmContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        confirmContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        
        confirmContainer.layoutIfNeeded()
        
        confirmContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: 0), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: 0))
        confirmContainer.layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.09), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.09))
        
        
        confirmContainer.addSubview(confirmField)
        confirmField.topAnchor.constraint(equalTo: confirmContainer.topAnchor, constant: 0).isActive = true
        confirmField.bottomAnchor.constraint(equalTo: confirmContainer.bottomAnchor, constant: 0).isActive = true
        confirmField.leadingAnchor.constraint(equalTo: confirmContainer.leadingAnchor, constant: 20).isActive = true
        confirmField.trailingAnchor.constraint(equalTo: confirmContainer.trailingAnchor, constant: -20).isActive = true
        
        
        view.addSubview(saveButton)
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.075).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = "Change Password"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
    }
    
    @objc func saveChanges()
    {
        guard let pass1 = passField.text, let pass2 = passField.text else {return}
        
        if pass1 == pass2
        {
            showIndicator("Changing Password", 2.0, completion: {
                LRServer.shared.changePassword(pass1) {
                    (error: Error?) in
                    DispatchQueue.main.async {
                        self.hideIndicator()
                        if error == nil
                        {
                            self.showResult("Password Changed", true, completion: {
                                self.passField.text = ""
                                self.confirmField.text = ""
                                self.hideIndicator()
                                self.navigationController?.popViewController(animated: true)
                            })
                        }
                        else
                        {
                            let alert = UIAlertController(title: "Password Error", message: "Error changing password", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                                self.passField.text = ""
                                self.confirmField.text = ""
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            })
        }
        else
        {
            let alert = UIAlertController(title: "Password Error", message: "The provided passwords do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.passField.text = ""
                self.confirmField.text = ""
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
}
