//
//  RegisterViewController.swift
//  Localevel
//
//  Created by Neil Ballard on 7/24/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    var selectedTextField = UITextField()
    var delegate:DidAuthorizeDelegate?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerTopConstraint: NSLayoutConstraint!
    @IBOutlet var containerBottomConstraint: NSLayoutConstraint!
    
    enum Fields: Int
    {
        case first
        case last
        case email
        case password
        case confirm
    }
    
    let closeImg : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "close_icon")
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let closeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica-Bold",size:35)
        label.textColor = UIColor.black
        label.text = "11th Table"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:15)//UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textColor = UIColor.subheader
        label.textAlignment = .center
        label.text = "Register below with your account information"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let basicLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:16)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.title
        label.textAlignment = .left
        label.text = "Basic Information"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:16)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.title
        label.textAlignment = .left
        label.text = "Login Credentials"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let phoneContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    let confirmContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var firstField : UITextField = {
        let field = UITextField()
        field.delegate = self
        field.backgroundColor = UIColor.clear
        field.autocapitalizationType = .words
        field.font = UIFont(name:"Helvetica",size:16)//UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        field.textColor = UIColor.black
        field.tag = Fields.first.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "Name",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var numberField : UITextField = {
        let field = UITextField()
        field.delegate = self
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"Helvetica",size:16)
        field.textColor = UIColor.black
        field.keyboardType = .numberPad
        field.tag = Fields.last.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "Phone Number",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var emailField : UITextField = {
        let field = UITextField()
        field.delegate = self
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"Helvetica",size:16)
        field.textColor = UIColor.black
        field.tag = Fields.email.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "email",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var passField : UITextField = {
        let field = UITextField()
        field.delegate = self
        field.backgroundColor = UIColor.clear
        field.font = UIFont(name:"Helvetica",size:16)
        field.textColor = UIColor.black
        field.isSecureTextEntry = true
        field.tag = Fields.password.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "password",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var repassField : UITextField = {
        let field = UITextField()
        field.delegate = self
        field.backgroundColor = UIColor.clear
        field.isSecureTextEntry = true
        field.font = UIFont(name:"Helvetica",size:16)
        field.textColor = UIColor.black
        field.tag = Fields.confirm.rawValue
        field.attributedPlaceholder = NSAttributedString(string: "re-enter password",
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
    
    let div2Line : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let div3Line : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let div4Line : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let registerButton : UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.LLGreen, for: .normal)
        button.titleLabel?.font = UIFont(name:"Helvetica-Bold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.LLGray.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let privacyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"Helvetica",size:10)//UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        label.textColor = UIColor.subheader
        label.textAlignment = .center
        label.text = "Your information will never be shared with a 3rd party"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardOnTap(#selector(self.dismissKeyboard))
        
        NotificationCenter.default.addObserver(self, selector: #selector(makeSpaceForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeSpaceForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        // Do any additional setup after loading the view.
        
        containerView.addSubview(closeButton)
        closeButton.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 28).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        closeButton.addSubview(closeImg)
        closeImg.centerXAnchor.constraint(equalTo: closeButton.centerXAnchor).isActive = true
        closeImg.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor).isActive = true
        closeImg.widthAnchor.constraint(equalTo: closeButton.widthAnchor, multiplier: 0.8).isActive = true
        closeImg.heightAnchor.constraint(equalTo: closeButton.heightAnchor, multiplier: 0.8).isActive = true
        
        
        let offset = UIScreen.main.bounds.height * 0.125
        let topoffset = UIScreen.main.bounds.height * 0.1

        containerView.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: topoffset).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0).isActive = true
      //  titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
     //   titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(basicLabel)
        basicLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: offset * 0.45).isActive = true
        basicLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        basicLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(firstContainer)
        firstContainer.topAnchor.constraint(equalTo: basicLabel.bottomAnchor, constant: 5).isActive = true
        firstContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        firstContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        firstContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        firstContainer.addSubview(firstField)
        firstField.topAnchor.constraint(equalTo: firstContainer.topAnchor, constant: 0).isActive = true
        firstField.bottomAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: 0).isActive = true
        firstField.leadingAnchor.constraint(equalTo: firstContainer.leadingAnchor, constant: 20).isActive = true
        firstField.trailingAnchor.constraint(equalTo: firstContainer.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(divLine)
        divLine.topAnchor.constraint(equalTo: firstContainer.bottomAnchor, constant: 0).isActive = true
        divLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        divLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        divLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        containerView.addSubview(phoneContainer)
        phoneContainer.topAnchor.constraint(equalTo: divLine.bottomAnchor, constant: offset * 0.0).isActive = true
        phoneContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        phoneContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        phoneContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        phoneContainer.addSubview(numberField)
        numberField.topAnchor.constraint(equalTo: phoneContainer.topAnchor, constant: 0).isActive = true
        numberField.bottomAnchor.constraint(equalTo: phoneContainer.bottomAnchor, constant: 0).isActive = true
        numberField.leadingAnchor.constraint(equalTo: phoneContainer.leadingAnchor, constant: 20).isActive = true
        numberField.trailingAnchor.constraint(equalTo: phoneContainer.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(div2Line)
        div2Line.topAnchor.constraint(equalTo: phoneContainer.bottomAnchor, constant: 0).isActive = true
        div2Line.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        div2Line.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        div2Line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        div2Line.isHidden = true
        
        containerView.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: div2Line.bottomAnchor, constant: offset * 0.25).isActive = true
        loginLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        loginLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(emailContainer)
        emailContainer.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 5).isActive = true
        emailContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        emailContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        emailContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        emailContainer.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 0).isActive = true
        emailField.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 0).isActive = true
        emailField.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor, constant: 20).isActive = true
        emailField.trailingAnchor.constraint(equalTo: emailContainer.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(div3Line)
        div3Line.topAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: 0).isActive = true
        div3Line.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        div3Line.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        div3Line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        containerView.addSubview(passwordContainer)
        passwordContainer.topAnchor.constraint(equalTo: div3Line.bottomAnchor, constant: offset * 0.0).isActive = true
        passwordContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        passwordContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        passwordContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        passwordContainer.addSubview(passField)
        passField.topAnchor.constraint(equalTo: passwordContainer.topAnchor, constant: 0).isActive = true
        passField.bottomAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 0).isActive = true
        passField.leadingAnchor.constraint(equalTo: passwordContainer.leadingAnchor, constant: 20).isActive = true
        passField.trailingAnchor.constraint(equalTo: passwordContainer.trailingAnchor, constant: -20).isActive = true

        containerView.addSubview(div4Line)
        div4Line.topAnchor.constraint(equalTo: passwordContainer.bottomAnchor, constant: 0).isActive = true
        div4Line.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        div4Line.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        div4Line.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        containerView.addSubview(confirmContainer)
        confirmContainer.topAnchor.constraint(equalTo: div4Line.bottomAnchor, constant: offset * 0.0).isActive = true
        confirmContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        confirmContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
        confirmContainer.heightAnchor.constraint(equalToConstant: offset * 0.55).isActive = true
        
        confirmContainer.addSubview(repassField)
        repassField.topAnchor.constraint(equalTo: confirmContainer.topAnchor, constant: 0).isActive = true
        repassField.bottomAnchor.constraint(equalTo: confirmContainer.bottomAnchor, constant: 0).isActive = true
        repassField.leadingAnchor.constraint(equalTo: confirmContainer.leadingAnchor, constant: 20).isActive = true
        repassField.trailingAnchor.constraint(equalTo: confirmContainer.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(privacyLabel)
        privacyLabel.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        privacyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        privacyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        
        containerView.addSubview(registerButton)
        registerButton.bottomAnchor.constraint(equalTo: privacyLabel.topAnchor, constant: -10).isActive = true
        registerButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        registerButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: offset * 0.6).isActive = true
        
        registerButton.setTitle("Get Started", for: .normal)

    }
    
    @objc func makeSpaceForKeyboard(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardHeight:CGFloat = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration:Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
                let frame = self.view.frame
                let offset = frame.size.height - keyboardHeight
            self.updateContainerY(keyboardY: offset, duration: duration)
        } else {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                self.containerTopConstraint.constant = 0
                self.containerBottomConstraint.constant = 0
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func registerTapped()
    {
        guard let first = firstField.text else
        {
            let alert = UIAlertController(title: "First name empty", message: "Please enter your first name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let number = numberField.text else
        {
            let alert = UIAlertController(title: "Phone Number empty", message: "Please enter your phone number.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
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
        
        guard let repassword = repassField.text else
        {
            let alert = UIAlertController(title: "Password cannot be empty", message: Credentials.infoErr.passwordFormat.rawValue, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                alert.dismiss(animated: false, completion: nil)
            }))
            present(alert, animated: true, completion: nil)

            return
        }
        
        let registerInfo = RegistrationInfo()
        
        
        if Credentials.isValidRegistration(info: registerInfo)
        {
            registerButton.isEnabled = false;
            showIndicator("Signing up", 0.0, completion: {})
            
            LRServer.shared.register(registerInfo) {
                (error: Error?) in
                
                if let err = error
                {
                    DispatchQueue.main.async {
                        self.registerButton.isEnabled = true
                        self.hideIndicator()
                        let alert = UIAlertController(title: "Registration Error", message: err.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            alert.dismiss(animated: false, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        self.registerButton.isEnabled = true
                        self.loadingIndicator.stopAnimating()
                        self.dismiss(animated: false, completion: {
                            if let registerDelegate = self.delegate
                            {
                                //registerDelegate.didSuccessfullyRegister(self)
                            }
                        })
                    }
                }
            }
        }
        else
        {
            let err = Credentials.registrationErr(info: registerInfo)
            
            if !err.isEmpty
            {
                let alert = UIAlertController(title: "Registration Error", message: err, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    alert.dismiss(animated: false, completion: nil)
                }))
                
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func closeTapped() {
        dismiss(animated: false, completion: nil)
    }
    
    func updateContainerY(keyboardY: CGFloat, duration: Double)
    {
        //just to be safe
        let offset = keyboardY - 100
        let textfield = self.selectedTextField
        if let view = textfield.superview
        {
            let y = view.frame.origin.y
            if offset < y
            {
                UIView.animate(withDuration: duration, animations: { () -> Void in
                    //add a little extra space
                    let val = (y - offset) + 50
                    self.containerTopConstraint.constant = -val
                    self.containerBottomConstraint.constant = val
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.numberField){
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: NSCharacterSet.decimalDigits.inverted)
            
            let decimalString = components.joined(separator: "") as NSString
            let length = decimalString.length
            let hasLeadingOne = length > 0 && decimalString.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3 {
                let areaCode = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3 {
                let prefix = decimalString.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalString.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.selectedTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func didSuccessfullyRegister(_ sender: OnboardingViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                self.delegate?.didSuccessfullyRegister(sender)
            })
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        // do aditional stuff
    }
 
}
