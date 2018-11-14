//
//  ProfileViewController.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/19/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let labels = ["Phone Number", "Payment Method", "Notifications", "Privacy & Terms", "Invite friends", "Sign out"]
    
    let icons = [#imageLiteral(resourceName: "phone_icon"), #imageLiteral(resourceName: "clip_Icon"), #imageLiteral(resourceName: "notification_icon"), #imageLiteral(resourceName: "privacy_icon"), #imageLiteral(resourceName: "invite_icon"), #imageLiteral(resourceName: "logout_icon")]
    
    let imagePicker = UIImagePickerController()
    
    let tableView : UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    let statusView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Account"
        // Do any additional setup after loading the view.
        setupView()
        imagePicker.delegate = self
        
        view.backgroundColor = .main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.setContentOffset(.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData()
    {
        tableView.reloadData()
    }
    
    func setupView(){
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let clearView = UIView()
        clearView.backgroundColor = UIColor.white
        UITableViewCell.appearance().selectedBackgroundView = clearView
        
        tableView.register(AccountCell.self, forCellReuseIdentifier: "accountCell")
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "profileCell")
        tableView.register(SettingsHeader.self, forCellReuseIdentifier: "header")
        tableView.backgroundColor = UIColor.clear
        
        view.addSubview(statusView)
        statusView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        statusView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        statusView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        statusView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 || section == 2
        {
            return 2
        }
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
            cell.backgroundColor = UIColor.white
            cell.imgView.image = #imageLiteral(resourceName: "profile_image")
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap))
            cell.imgView.addGestureRecognizer(tap)
            
            if let model = Defaults.getUser()
            {
                if let first = model.first
                {
                    cell.nameLabel.text = first
                }
            }
            
            cell.changeLabel.text = "change password"

            /*
            if let model = Defaults.getUser()
            {
                if let first = model.first
                {
                    if let last = model.last
                    {
                        cell.nameLabel.text = String(format: "%@ %@", first, last)
                    }
                    else
                    {
                        cell.nameLabel.text = first
                    }
                }
                
                if let email = model.email
                {
                    cell.emailLabel.text = email
                }
            } */
            
            return cell
        }
        else if indexPath.section == 1
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
            
            cell.accountLabel.text = labels[indexPath.row]
            cell.iconImg.image = icons[indexPath.row]
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        else if indexPath.section == 2
        {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
            
            cell.accountLabel.text = labels[indexPath.row + indexPath.section]
            cell.iconImg.image = icons[indexPath.row + indexPath.section]
            cell.accessoryType = .disclosureIndicator
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountCell
            
            cell.backgroundColor = UIColor.white
            cell.accessoryType = .disclosureIndicator
            cell.accountLabel.text = labels[indexPath.section + 1]
            cell.iconImg.image = icons[indexPath.section + 1]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0
        {
            guard let header = tableView.dequeueReusableCell(withIdentifier: "header") as? SettingsHeader else {
                return nil
            }
            
            header.headerLabel.text = "Settings"
            
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0
        {
            return 90
        }
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0
        {
            return UIScreen.main.bounds.height * 0.2
        }
        
        return UIScreen.main.bounds.height * 0.09
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    let message: [Message] = messages[indexPath.row]

        switch indexPath.section
        {
        case 0:
            changePassword()
            break
        case 1:
            if indexPath.row == 0
            {
                phoneNumber()
            }
            else
            {
                paymentMethod()
            }
            break
        case 2:
            if indexPath.row == 0
            {
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            else
            {
                viewPrivacy()
            }
            break
        case 3:
            inviteFriends()
            break
        case 4:
            logout()
            break
        default:
            break
        }
    }
    
    @objc func handleImageTap() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //do server method
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as! ProfileCell
            cell.imgView.contentMode = .scaleAspectFill
            cell.imgView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func changeMode()
    {
        /*
        if let tabBar: LLTabBarViewController = self.tabBarController as? LLTabBarViewController
        {
            tabBar.swapModeSelection()
        } */
    }
    
    private func changePassword()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToPasswordChange()
        }
    }
    
    private func paymentMethod()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToPaymentMethod()
        }
    }

    private func phoneNumber()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToPhoneNumber()
        }
    }
    
    private func inviteFriends()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToContactInvite()
        }
    }
    
    private func viewPrivacy()
    {
        if let tabBar: TabBarController = self.tabBarController as? TabBarController
        {
            tabBar.goToPrivacy()
        }
    }
    
    private func logout()
    {
        let alert = UIAlertController(title: "Logout", message: "Logout of Late Reservation?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
           
            AuthorizationKeychain.shared.removeAuthCode()
            Defaults.setLoginStatus(status: false)
            Defaults.clearUserData()
            if let tabBar: TabBarController = self.tabBarController as? TabBarController
            {
                tabBar.checkForLoginStatus()
            }
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { (_) in
            alert.dismiss(animated: false, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

class AccountCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let iconImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "phone_icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let accountLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.header
        label.font = UIFont(name:"SourceSansPro-Regular",size:15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    
    func setupViews() {
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        viewContainer.addSubview(iconImg)
        iconImg.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true;
        iconImg.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 25).isActive = true
        
        viewContainer.addSubview(accountLabel)
        accountLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true;
        accountLabel.leadingAnchor.constraint(equalTo: iconImg.trailingAnchor, constant: 10).isActive = true
        accountLabel.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -20).isActive = true
        
        layoutIfNeeded()
        
        layer.drawLine(fromPoint: CGPoint(x: 0, y: frame.minY), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: frame.minY))
        layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.09), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.09))
        
        /*
         viewContainer.addSubview(accountSwitch)
         accountSwitch.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor).isActive = true;
         accountSwitch.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor, constant: -15).isActive = true */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}

class ProfileCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let topView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.main
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let imgView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.header
        label.font = UIFont(name:"SourceSansPro-Bold",size:18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.subheader
        label.font = UIFont(name:"SourceSansPro-Regular",size:14)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let disclosureImg : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "disclosure")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func setupViews() {
        
        addSubview(topView)
        topView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        topView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        topView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        addSubview(viewContainer)
        viewContainer.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        viewContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        viewContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        
        let imgSize = UIScreen.main.bounds.height * 0.1
        viewContainer.addSubview(imgView)
        imgView.heightAnchor.constraint(equalToConstant: imgSize).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: imgSize).isActive = true
        //    imgView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0).isActive = true
        imgView.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0).isActive = true;
        //  imgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
        imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        imgView.layer.cornerRadius = (imgSize) / 2
        
        viewContainer.addSubview(changeLabel)
        changeLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 20).isActive = true
        changeLabel.topAnchor.constraint(equalTo: imgView.centerYAnchor, constant: 0).isActive = true
        
        viewContainer.addSubview(nameLabel)
        nameLabel.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: 0).isActive = true;
        nameLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 19).isActive = true
    
        viewContainer.addSubview(disclosureImg)
        disclosureImg.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor, constant: 0).isActive = true;
        disclosureImg.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        
        layoutIfNeeded()
        
        layer.drawLine(fromPoint: CGPoint(x: 0, y: viewContainer.frame.minY), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: viewContainer.frame.minY))
        layer.drawLine(fromPoint: CGPoint(x: 0, y: UIScreen.main.bounds.height * 0.2), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height * 0.2))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}
