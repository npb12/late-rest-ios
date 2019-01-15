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
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: "res_image")
        return imageView
    }()
    
    //bluePatternView.backgroundColor = UIColor(patternImage: UIImage(named: "blue_pattern")!)
    
    let chainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(patternImage: UIImage.init(named: "chain_img")!)
        return view
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    let closeImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.init(imageLiteralResourceName: "close_icon")
        return imageView
    }()

    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Pacifico-Regular",size:35)
        label.textColor = UIColor.white
        label.text = "11th Table"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:20)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Discounted tables at the 11th hour"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let btnShadow : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.LRPinkShadow.cgColor
        view.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        view.layer.shadowOpacity = 0.4;
        view.layer.shadowRadius = 5.0;
       // view.layer.masksToBounds = false
        return view
    }()
    
    let emailField : VersatileTextField = {
        let field = VersatileTextField()
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        field.placeholderFont = UIFont(name:"SourceSansPro-SemiBold",size:16)
        field.tag = Fields.email.rawValue
        field.textColor = UIColor.white
        field.lineColor = UIColor.lightGray
        field.placeholderColor = UIColor.white
        field.selectedLineColor = UIColor.white
        field.selectedTitleColor = UIColor.white
        field.placeholder = "email"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let divLine : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passField : VersatileTextField = {
        let field = VersatileTextField()
        field.backgroundColor = UIColor.clear
        field.isSecureTextEntry = true
        field.textColor = UIColor.white
        field.lineColor = UIColor.lightGray
        field.placeholderColor = UIColor.white
        field.selectedLineColor = UIColor.white
        field.selectedTitleColor = UIColor.white
        field.placeholder = "password"
        field.font = UIFont(name:"SourceSansPro-SemiBold",size:18)
        field.placeholderFont = UIFont(name:"SourceSansPro-SemiBold",size:16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("SIGN IN", for: .normal)
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name:"SourceSansPro-SemiBold",size:16)//UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
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
        label.font = UIFont(name:"SourceSansPro-SemiBold",size:17)//UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white
        label.textAlignment = .center
        let attributedString = NSMutableAttributedString(string:"Need an account? Register")
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
        label.font = UIFont(name:"SourceSansPro-Regular",size:15)//UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "Forgot your password?"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        UITextField.appearance().tintColor = UIColor.LROffTone
        

        let offset = UIScreen.main.bounds.height * 0.125
        
        
        view.addSubview(imgView)
        imgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(chainView)
        chainView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        chainView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chainView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chainView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(cancelButton)
        cancelButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.addSubview(closeImage)
        closeImage.centerXAnchor.constraint(equalTo: cancelButton.centerXAnchor).isActive = true
        closeImage.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        closeImage.heightAnchor.constraint(equalToConstant: 25).isActive = true
        closeImage.widthAnchor.constraint(equalToConstant: 25).isActive = true

        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
   //     titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
   //     titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        view.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25).isActive = true
        
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
        passwordContainer.topAnchor.constraint(equalTo: divLine.bottomAnchor, constant: offset * 0.25).isActive = true
        passwordContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        passwordContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        passwordContainer.addSubview(passField)
        passField.topAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: 0).isActive = true
        passField.bottomAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 0).isActive = true
        passField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor, constant: 20).isActive = true
        passField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor, constant: -20).isActive = true

        view.addSubview(btnShadow)
        btnShadow.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: offset * 0.25).isActive = true
        btnShadow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        btnShadow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        btnShadow.heightAnchor.constraint(equalToConstant: offset * 0.65).isActive = true
        
        btnShadow.addSubview(loginButton)
        loginButton.topAnchor.constraint(equalTo: btnShadow.topAnchor).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: btnShadow.leadingAnchor, constant: 0).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: btnShadow.trailingAnchor, constant:0).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: btnShadow.bottomAnchor).isActive = true

        view.addSubview(forgotButton)
        forgotButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 15).isActive = true
        forgotButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        forgotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        forgotButton.heightAnchor.constraint(equalToConstant: offset * 0.3).isActive = true
        
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
    
    func didSuccessfullyRegister(_ sender: OnboardingViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                self.delegate?.didSuccessfullyRegister(sender)
            })
        }
    }
    
    @objc func closeTapped()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let registerViewController = segue.destination as? OnboardingViewController
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
            //self.addAttribute(.link, value: "", range: foundRange)
            self.addAttribute(.font, value: UIFont(name:"SourceSansPro-Bold",size:17), range: foundRange)
            self.addAttribute(.foregroundColor, value: UIColor.white, range: foundRange)
            self.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: foundRange)
            return true
        }
        return false
    }
}

