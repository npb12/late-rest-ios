//
//  OnboardingView.swift
//  Localevel
//
//  Created by Neil Ballard on 7/20/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class OnboardingViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate
{
    
    var startBottom : NSLayoutConstraint?
    
    var delegate:DidAuthorizeDelegate?
    var currentIndex = 0
    var nextLastButton = false
    var registrationInfo : RegistrationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(OnboardingItemView.self, forCellWithReuseIdentifier: "pageId")
        collectionView?.isPagingEnabled = true
        collectionView?.isScrollEnabled = false
        
        registrationInfo = RegistrationInfo()
        
        NotificationCenter.default.addObserver(self, selector: #selector(makeSpaceForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeSpaceForKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        view.addSubview(startButton)
        startButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        startBottom = startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: UIScreen.main.bounds.height * 0.1)
        startBottom?.isActive = true
    }
    
    @objc func makeSpaceForKeyboard(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardHeight:CGFloat = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration:Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                if let bottom = self.startBottom
                {
                    bottom.constant = -keyboardHeight
                }
            })
        } else {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                if let bottom = self.startBottom
                {
                    bottom.constant = 0
                }
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if currentIndex == 0
        {
            let cell = collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as! OnboardingItemView
            cell.textField.becomeFirstResponder()
        }
    }
    
    let startButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name:"SourceSansPro-SemiBold",size:18)//UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor.LROffTone
        button.layer.borderColor = UIColor.LROffTone.cgColor
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.layer.borderWidth = 0.5
        button.alpha = 0.2
        button.isUserInteractionEnabled = false
        //button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if nextLastButton
        {
            if currentIndex > 0
            {
                let cell = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? OnboardingItemView
                if let next = cell
                {
                    next.textField.becomeFirstResponder()
                }
            }
        }
        else
        {
            let cell = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as? OnboardingItemView
            if let next = cell
            {
                next.textField.becomeFirstResponder()
            }
        }
        
        if currentIndex > 1
        {
            startButton.setTitle("Get Started", for: .normal)
        }
        else
        {
            startButton.setTitle("Next", for: .normal)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageId", for: indexPath) as! OnboardingItemView
        cell.onboardingPageInfo = pages[indexPath.row]
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cell.closeButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        if let info = registrationInfo
        {
            switch indexPath.row
            {
            case 0:
                cell.textField.text = info.first
                cell.textField.autocapitalizationType = .words
                break
            case 1:
                cell.textField.text = info.email
                break
            case 2:
                cell.textField.text = info.password
                break
            default:
                break
            }
        }
    
        
        if indexPath.row == 2
        {
            cell.textField.keyboardType = .default
            cell.textField.isSecureTextEntry = true
        }
        else
        {
            cell.textField.keyboardType = .default
            cell.textField.isSecureTextEntry = false
        }
        
        if let text = cell.textField.text
        {
            verifyFieldInput(cell, text, indexPath.row)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.65)
        }
        
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 2)
    }
    
    @objc func backTapped()
    {
        nextLastButton = false
        let curr = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! OnboardingItemView
        curr.textField.resignFirstResponder()
        if currentIndex == 0
        {
            dismiss(animated: true, completion: nil)
            return
        }
        setInfo(curr, currentIndex)
        
        currentIndex -= 1
        collectionView?.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func nextTapped()
    {
        nextLastButton = true
        let curr = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! OnboardingItemView
        curr.textField.resignFirstResponder()
        setInfo(curr, currentIndex)
        if currentIndex == pages.count - 1
        {
            registerTapped()
            return
        }
        
        currentIndex += 1
        collectionView?.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField:UITextField) {
        
        let cell = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! OnboardingItemView
        
        if let text = textField.text
        {
            verifyFieldInput(cell, text, currentIndex)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
        /*
        if currentIndex == 1{
            
            let cell = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! OnboardingItemView
            verifyFieldInput(cell, textField.text!, currentIndex)
            
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
        } */
    }
    
    func setInfo(_ cell : OnboardingItemView, _ row : Int)
    {
        
        guard let text = cell.textField.text else {return}
        
        switch row
        {
        case 0:
            registrationInfo?.first = text
            break
        case 1:
            registrationInfo?.email = text
            break
        case 2:
            registrationInfo?.password = text
            break
        default:
            break
        }
    }
    
    func verifyFieldInput(_ cell : OnboardingItemView, _ text : String, _ row : Int)
    {
        var valid = false
        
        switch row {
        case 0:
            if Credentials.validNameLength(str: text) && Credentials.validNameFormat(str: text)
            {
                valid = true
            }
            break
        case 1:
            if Credentials.isValidEmail(text)
            {
                valid = true
            }
            break
        case 2:
            if Credentials.validPassword(str: text)
            {
                valid = true
            }
            break
        default:
            break
        }
        
        if valid
        {
            startButton.alpha = 1.0
            startButton.isUserInteractionEnabled = true
        }
        else
        {
            startButton.alpha = 0.2
            startButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func registerTapped()
    {
        guard let info = registrationInfo else { return }
        
        if Credentials.isValidRegistration(info: info)
        {
            startButton.isEnabled = false;
            showIndicator("Signing up", 0.0, completion: {})
            
            LRServer.shared.register(info) {
                (error: Error?) in
                
                if let err = error
                {
                    DispatchQueue.main.async {
                        self.startButton.isEnabled = true
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
                        self.startButton.isEnabled = true
                        self.loadingIndicator.stopAnimating()
                        self.dismiss(animated: false, completion: {
                            if let registerDelegate = self.delegate
                            {
                                registerDelegate.didSuccessfullyRegister(self)
                            }
                        })
                    }
                }
            }
        }
        else
        {
            let err = Credentials.registrationErr(info: info)
            
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
    
    func didSuccessfullyRegister(_ sender: OnboardingViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: {
                self.delegate?.didSuccessfullyRegister(sender)
            })
        }
    }
}
