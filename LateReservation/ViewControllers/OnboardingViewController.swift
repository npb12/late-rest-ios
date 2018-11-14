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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if currentIndex == 0
        {
            let cell = collectionView?.cellForItem(at: IndexPath(row: 0, section: 0)) as! OnboardingItemView
            cell.textField.becomeFirstResponder()
        }
    }
    
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
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageId", for: indexPath) as! OnboardingItemView
        cell.onboardingPageInfo = pages[indexPath.row]
        cell.textField.delegate = self
        cell.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        cell.startButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        cell.closeButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        if let info = registrationInfo
        {
            switch indexPath.row
            {
            case 0:
                cell.textField.text = info.first
                break
            case 1:
                cell.textField.text = info.phone
                break
            case 2:
                cell.textField.text = info.email
                break
            case 3:
                cell.textField.text = info.password
                break
            case 4:
                cell.textField.text = info.confirm
                break
            default:
                break
            }
        }
        
        if indexPath.row < 4
        {
            cell.startButton.setTitle("Next", for: .normal)
        }
        else
        {
            cell.startButton.setTitle("Get Started", for: .normal)
        }
        
        if indexPath.row > 2
        {
            cell.textField.isSecureTextEntry = true
            cell.textField.keyboardType = .numberPad
        }
        else if indexPath.row == 1
        {
            cell.textField.keyboardType = .numberPad
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
        if currentIndex == 1{
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
    
    func setInfo(_ cell : OnboardingItemView, _ row : Int)
    {
        
        guard let text = cell.textField.text else {return}
        
        switch row
        {
        case 0:
            registrationInfo?.first = text
            break
        case 1:
            registrationInfo?.phone = text
            break
        case 2:
            registrationInfo?.email = text
            break
        case 3:
            registrationInfo?.password = text
            break
        case 4:
            registrationInfo?.confirm = text
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
            valid = true
            /*
            if Credentials.validPhoneNumber(str: text)
            {
                valid = true
            } */
            break
        case 2:
            if Credentials.isValidEmail(text)
            {
                valid = true
            }
            break
        case 3...4:
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
            cell.startButton.alpha = 1.0
            cell.startButton.isUserInteractionEnabled = true
        }
        else
        {
            cell.startButton.alpha = 0.2
            cell.startButton.isUserInteractionEnabled = false
        }
    }
    
    @objc func registerTapped()
    {
        guard let info = registrationInfo else { return }
        
        let cell = collectionView?.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! OnboardingItemView
        
        if Credentials.isValidRegistration(info: info)
        {
            cell.startButton.isEnabled = false;
            showIndicator("Signing up", 0.0, completion: {})
            
            LRServer.shared.register(info) {
                (error: Error?) in
                
                if let err = error
                {
                    DispatchQueue.main.async {
                        cell.startButton.isEnabled = true
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
                        cell.startButton.isEnabled = true
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
