//
//  LoginViewController.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate, DidAuthorizeDelegate {
    
    
    enum Fields: Int
    {
        case email
        case password
    }
    
    var delegate:DidAuthorizeDelegate?
    
    /*
    let titleLabel : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //  imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "local_logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }() */
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:35)
        label.textColor = UIColor.black
        label.text = "Late Reservation"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:16)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.subheader
        label.textAlignment = .center
        label.text = "Last minute discounted dining at high end venues"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailField : UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"Helvetica",size:18)//UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        field.textColor = UIColor.black
        field.tag = Fields.email.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "email",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let divLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passField : UITextField = {
        let field = UITextField()
        field.backgroundColor = UIColor.clear
        field.isSecureTextEntry = true
        field.font = UIFont(name:"Helvetica",size:18)//UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        field.textColor = UIColor.black
        field.tag = Fields.password.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "password",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.LLGreen, for: .normal)
        button.titleLabel?.font = UIFont(name:"Helvetica-Bold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.LLGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let registerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:17)//UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.textColor = UIColor.subheader
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string:"Need an account? Register.")
        let linkWasSet = attributedString.setAsLink(textToFind: "Register")
        
        if linkWasSet
        {
            label.attributedText = attributedString
        }
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let forgotButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.addTarget(self, action: #selector(forgotTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPasswordLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:13)//UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.blueLiteTwo
        label.textAlignment = .center
        label.text = "Forgot your password?"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))

        
        let offset = UIScreen.main.bounds.height * 0.125
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
   //     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
   //     titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(emailContainer)
        emailContainer.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: offset * 0.55).isActive = true
        emailContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        emailContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        emailContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        emailContainer.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 0).isActive = true
        emailField.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 0).isActive = true
        emailField.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor, constant: 20).isActive = true
        emailField.trailingAnchor.constraint(equalTo: emailContainer.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(divLine)
        divLine.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 0).isActive = true
        divLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        divLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        divLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        view.addSubview(passwordContainer)
        passwordContainer.topAnchor.constraint(equalTo: divLine.bottomAnchor, constant: offset * 0.0).isActive = true
        passwordContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        passwordContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        passwordContainer.addSubview(passField)
        passField.topAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: 0).isActive = true
        passField.bottomAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 0).isActive = true
        passField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor, constant: 20).isActive = true
        passField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: offset * 0.25).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: offset * 0.6).isActive = true
        
        view.addSubview(forgotButton)
        forgotButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15).isActive = true
        forgotButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        forgotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        forgotButton.heightAnchor.constraint(equalToConstant: offset * 0.2).isActive = true
        
        forgotButton.addSubview(forgotPasswordLabel)
        forgotPasswordLabel.topAnchor.constraint(equalTo: forgotButton.topAnchor, constant: 0).isActive = true
        forgotPasswordLabel.bottomAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: 0).isActive = true
        forgotPasswordLabel.leadingAnchor.constraint(equalTo: forgotButton.leadingAnchor, constant: 0).isActive = true
        forgotPasswordLabel.trailingAnchor.constraint(equalTo: forgotButton.trailingAnchor, constant: 0).isActive = true
        
        view.addSubview(registerButton)
        registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: offset * 0.5).isActive = true
        
        registerButton.addSubview(registerLabel)
        registerLabel.topAnchor.constraint(equalTo: registerButton.topAnchor, constant: 0).isActive = true
        registerLabel.bottomAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 0).isActive = true
        registerLabel.leadingAnchor.constraint(equalTo: registerButton.leadingAnchor, constant: 0).isActive = true
        registerLabel.trailingAnchor.constraint(equalTo: registerButton.trailingAnchor, constant: 0).isActive = true

        /*
        view.addSubview(orLabel)
        orLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: offset * 0.2).isActive = true
        orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(leftLine)
        leftLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        leftLine.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -20).isActive = true
        leftLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        view.addSubview(rightLine)
        rightLine.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor).isActive = true
        rightLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        rightLine.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 20).isActive = true
        rightLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        view.addSubview(linkedinButton)
        linkedinButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: offset * 0.2).isActive = true
        linkedinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        linkedinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        linkedinButton.heightAnchor.constraint(equalToConstant: offset * 0.5).isActive = true
        
        */
        /*
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loginTapped() {
        
        guard let email = emailField.text else
        {
            let alert = UIAlertController(title: "Email cannot be empty", message: "Please enter a valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let password = passField.text else
        {
            let alert = UIAlertController(title: "Password cannot be empty", message: Credentials.infoErr.passwordFormat.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let loginInfo = LoginInfo(email: email, password: password)
        
        if Credentials.isValidLogin(info: loginInfo)
        {
            loginButton.isEnabled = false;
            showIndicator("Logging in", 0.0, completion: {})
            LRServer.shared.authorize(loginInfo) {
                (error: Error?) in
                
                if let err = error
                {
                    DispatchQueue.main.async {
                        self.loginButton.isEnabled = true
                        self.hideIndicator()
                        let alert = UIAlertController(title: "Login Error", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            alert.dismiss(animated: false, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.loginButton.isEnabled = true;
                        self.hideIndicator()
                        self.dismiss(animated: true, completion: {
                            if let loginDelegate = self.delegate
                            {
                                loginDelegate.didSuccessfullyLogin(self)
                            }
                        })
                    }
                }
            }
        }
        else
        {
            let err = Credentials.loginErr(info: loginInfo)
            
            if !err.isEmpty
            {
                let alert = UIAlertController(title: "Login Error", message: err, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    alert.dismiss(animated: false, completion: nil)
                }))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func registerTapped()
    {
        performSegue(withIdentifier: "registerSegue", sender: self)
    }
    
    @objc func forgotTapped()
    {

    }
    
    func didSuccessfullyLogin(_ sender: LoginViewController){}
    
    func didSuccessfullyRegister(_ sender: RegisterViewController) {
        
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                self.delegate?.didSuccessfullyRegister(sender)
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let registerViewController = segue.destination as? RegisterViewController
        {
            registerViewController.delegate = self
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
}

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
           // self.addAttribute(.underlineColor, value: UIColor.blueLiteOne, range: foundRange)
            self.addAttribute(.link, value: "", range: foundRange)
            self.addAttribute(.font, value: UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold), range: foundRange)
            return true
        }
        return false
    }
}

