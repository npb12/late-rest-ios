//
//  AngelInviteViewController.swift
//  Localevel
//
//  Created by Neil Ballard on 8/28/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import MessageUI

class InviteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMessageComposeViewControllerDelegate {

    var contacts:[CNContact] = []
    let sections:[String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
    
    let tableView : UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.main
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "Invite Friends"
        view.backgroundColor = UIColor.main
        
        setupNavbar()
        setupView()
        
        self.getContacts()
        /*
        if Defaults.getUserMode() == Defaults.UserMode.investor
        {
            titleLabel.text = "Form an angel group"
            descLabel.text = "\"89% of investors identify prospective investments through angel groups\""
        }
        else
        {
            titleLabel.text = "Invite a friend with a startup"
            descLabel.text = "\"Investors are five times more likely to invest locally\""
        } */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationBar.topItem?.title = "Invite Friends"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "SourceSansPro-Regular", size: 16)!]
    }
    
    func setupNavbar()
    {
        guard let navController = self.navigationController else
        {
            return
        }
        
        navController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navController.navigationBar.shadowImage = UIImage()
        navController.navigationBar.isTranslucent = true
        navController.view.backgroundColor = .clear
        
        let bounds = navController.navigationBar.bounds
        drawLine(onLayer: navController.navigationBar.layer, fromPoint: CGPoint(x: 0, y: bounds.height), toPoint: CGPoint(x: UIScreen.main.bounds.width, y: bounds.height))
        navController.navigationBar.barTintColor = UIColor.clear
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        frost.frame = CGRect(x: 0, y: -20, width: bounds.width, height: bounds.height + 20)
        navController.navigationBar.insertSubview(frost, at: 0)
    }
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.fillColor = nil
        line.opacity = 1.0
        line.lineWidth = 0.1
        line.strokeColor = UIColor.LLGray.cgColor
        layer.addSublayer(line)
    }

    func setupView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let clearView = UIView()
        clearView.backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectedBackgroundView = clearView
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: "contactCell")
        tableView.backgroundColor = UIColor.main
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return getContactsForSection(sections[section]).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactCell
        
        if indexPath.section == 0
        {
            return cell
        }
        
        let contact = getContactsForSection(sections[indexPath.section])[indexPath.row]
        cell.selectionStyle = .none
        cell.nameLabel.text = String.init(format: "%@ %@", contact.givenName, contact.familyName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if section > 0
        {
            let string = sections[section]
            return string
        }

        return nil
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]?
    {
        return sections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.065
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.section == 0
        {
            return
        }
        
        let contact = getContactsForSection(sections[indexPath.section])[indexPath.row]
        let phones = contact.phoneNumbers
        var cellPhone:String? = nil
        
        for phone in phones
        {
            let label:String = phone.label ?? ""
            let value:String = phone.value.stringValue
            
            if label == CNLabelPhoneNumberMobile || label == CNLabelPhoneNumberiPhone || label == CNLabelHome
            {
                cellPhone = value
            }
        }
        
        guard let number = cellPhone else { return }
        
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        
        // Configure the fields of the interface.
        composeVC.recipients = [number]
        
        //replace with message + app link
        composeVC.body = "Hey download 11th Table for exclusive discounts at restaurants!\nhttps://itunes.apple.com/us/app/11th-table/id1444916887?mt=8"
        
        // Present the view controller modally.
        DispatchQueue.main.async {
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Compose Message
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        DispatchQueue.main.async {
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: -
    // MARK: Contacts
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func getContacts()
    {
        let store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if (status == .authorized)
        {
            self.retrieveContactsWithStore(store: store)
        }
        else
        {
            store.requestAccess(for: .contacts, completionHandler:
                { (authorized, error) in
                    if (authorized)
                    {
                        self.retrieveContactsWithStore(store: store)
                    }
            })
        }
    }
    
    func retrieveContactsWithStore(store:CNContactStore)
    {
        do
        {
            let containers = try store.containers(matching: nil)
            
            self.contacts = []
            for container in containers
            {
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                let keysToFetch:[CNKeyDescriptor] = [CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactGivenNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactNoteKey as CNKeyDescriptor]
                
                let contacts:[CNContact] = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
                
                self.contacts.append(contentsOf: contacts)
            }
            
            self.contacts = self.contacts.sorted(by: {$0.familyName < $1.familyName})
            
            DispatchQueue.main.async
                {
                    self.tableView.reloadData()
            }
        }
        catch
        {
            print(error)
        }
    }
    
    func getContactsForSection(_ sectionTitle:String) -> [CNContact]
    {
        return contacts.filter({ (contact) -> Bool in
            contact.familyName.starts(with: sectionTitle)
        })
    }
    
    @IBAction func goBack(_ sender: Any)
    {
        navigationController?.popViewController(animated: true)
    }
}

class ContactCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    let viewContainer : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.main
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SourceSansPro-Regular", size: 18)
        label.textColor = UIColor.header
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
        
        viewContainer.addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
}


