//
//  ConfirmReservation.swift
//  LateReservation
//
//  Created by Neil Ballard on 9/27/18.
//  Copyright © 2018 Neil Ballard. All rights reserved.
//

import Foundation
import UIKit


class ChooseReservationViewController : BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, ConfirmReservationDelegate
{
    var delegate : ReservationAvailableDelegate?
    
    var restaurant = Restaurant()
    
    var partyRow = 0
    var selectedTime = ""
    
    @IBOutlet var likeBtn: UIBarButtonItem!
    
    var listOfParty: [String] = [String]()
    var listOfTimes: [String] = [String]()
    var assocData: [ReservationTracker] = [ReservationTracker]()

    @IBOutlet var reserveButton: UIButton!
    
    let titleLabel : UILabel = {
        let label = UILabel()
        //label.font = UIFont.systemFont(ofSize: 21, weight: UIFont.Weight.semibold)
        label.font = UIFont(name:"SourceSansPro-Bold",size:26)
        label.textAlignment = .center
        label.textColor = UIColor.title
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:12)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let todayLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:17)
        label.textColor = .title
        label.textAlignment = .center
        label.text = "Today"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let partyLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:17)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Party of"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name:"SourceSansPro-Regular",size:17)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Reservation time"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let partyPicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let timePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        partyPicker.dataSource = self
        partyPicker.delegate = self
        timePicker.dataSource = self
        timePicker.delegate = self
        
        titleLabel.text = restaurant.restaurantName
        locationLabel.text = restaurant.location
        reserveButton.titleLabel?.font = UIFont(name: "SourceSansPro-Bold", size: 19)//UIFont.systemFont(ofSize: 19, weight: .semibold)
        let buttonTitle = String(format: "RESERVE | %d%% OFF", (restaurant.reservations[0].discount))
        reserveButton.setTitle(buttonTitle, for: .normal)
        
        
        if Favorites.isFavorited(id: restaurant.id)
        {
            likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
        }
        else
        {
            likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
        }
        
        listOfParty.removeAll()
        let reservations = restaurant.reservations
        if reservations.count > 0
        {
            for res in reservations
            {
                listOfParty.appendIfNotContains(String(res.party))
            }
            listOfParty.sort()
            partyPicker.reloadAllComponents()
            orderTimes(listOfParty[0])
            let btnTitle = String(format: "RESERVE | %d%% OFF", reservations[0].discount)
            reserveButton.setTitle(btnTitle, for: .normal)
        }
    }
    
    func orderTimes(_ selectedParty : String)
    {
        listOfTimes.removeAll()
        assocData.removeAll()
        if let party = Int(selectedParty)
        {
            let reservations = restaurant.reservations
            if reservations.count > 0
            {
                for res in reservations
                {
                    if res.party >= party && party >= res.minParty
                    {
                        var data = ReservationTracker()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "h:mm a"
                        formatter.timeZone = TimeZone.current
                        let dateString = formatter.string(from: res.reservationTime!)
                        data.restId = res.tableId
                        data.timeStr = dateString
                        assocData.append(data)
                        listOfTimes.append(dateString)
                    }
                }
            }
        }
        listOfTimes = listOfTimes.sorted{ $0 > $1 }
        if listOfTimes.count > 0
        {
            selectedTime = listOfTimes.first!
        }
        timePicker.reloadAllComponents()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      //  self.navigationController?.navigationBar.topItem?.title = "Dijon's Steak & Lobster House"
     //   self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Didot-Italic", size: 16)!]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirmViewController = segue.destination as? ConfirmReservationViewController
        {
            let reservation = sender as! LateReservation
            confirmViewController.reservation = reservation
            confirmViewController.party = Int(listOfParty[partyRow])!
            confirmViewController.delegate = self
            confirmViewController.modalPresentationStyle = .overFullScreen
            confirmViewController.view.backgroundColor = UIColor.clear
            confirmViewController.view.isOpaque = false
        }
    }
    
    func setupViews()
    {
        reserveButton.backgroundColor = UIColor.white//UIColor.black.withAlphaComponent(0.8)
        reserveButton.setTitleColor(.goldmember, for: .normal)
        reserveButton.layer.borderColor = UIColor.LLDiv.cgColor
        reserveButton.layer.borderWidth = 1
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        
        view.addSubview(locationLabel)
        locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        locationLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(todayLabel)
        todayLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        todayLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        todayLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        view.addSubview(partyPicker)
        partyPicker.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 15).isActive = true
        partyPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        partyPicker.trailingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        partyPicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25).isActive = true
        
        view.addSubview(timePicker)
        timePicker.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 15).isActive = true
        timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        timePicker.leadingAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.25).isActive = true
        
        view.addSubview(partyLabel)
        partyLabel.topAnchor.constraint(equalTo: partyPicker.bottomAnchor, constant: 5).isActive = true
        partyLabel.centerXAnchor.constraint(equalTo: partyPicker.centerXAnchor).isActive = true
        
        view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 5).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: timePicker.centerXAnchor).isActive = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == partyPicker {
            return listOfParty.count
        }
        
        return listOfTimes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == partyPicker {
            return listOfParty[row]
        }
        else {
            return listOfTimes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == partyPicker
        {
            let party = listOfParty[row]
            orderTimes(party)
            partyRow = row
        }
        else
        {
            selectedTime = listOfTimes[row]
        }
        
        updateDiscount()
    }
    
    func updateDiscount()
    {
        var selectedId : Int = 0
        var discount : Int = 0
        for res in assocData
        {
            if res.timeStr == selectedTime
            {
                selectedId = res.restId
                break
            }
        }
        
        for res in restaurant.reservations
        {
            if selectedId == res.tableId
            {
                discount = res.discount
                break
            }
        }
        
        let buttonTitle = String(format: "RESERVE | %d%% OFF", discount)
        reserveButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func selectedReservation(_ sender: Any) {
        
        var reservation : LateReservation? = nil
        var reservationId = -1
        
        for data in assocData
        {
            if data.timeStr == selectedTime
            {
                reservationId = data.restId
                break
            }
        }
        
        let reservations = restaurant.reservations
        if reservations.count > 0
        {
            for res in reservations
            {
                if reservationId == res.tableId
                {
                    reservation = res
                    break
                }
            }
        }
        
        if reservation != nil
        {
            performSegue(withIdentifier: "confirmSegue", sender: reservation)
        }
    }
    
    @IBAction func likeRest(_ sender: Any) {
        if Favorites.isFavorited(id: restaurant.id)
        {
            likeBtn.image = #imageLiteral(resourceName: "favorite_icon").withRenderingMode(.alwaysOriginal)
            if let favId = Favorites.getFavoritedId(id: restaurant.id)
            {
                LRServer.shared.deleteFavorite(favId, completion: {
                    DispatchQueue.main.async {
                        //             self.updateTabVC()
                    }
                })
            }
        }
        else
        {
            likeBtn.image = #imageLiteral(resourceName: "like_active_nav").withRenderingMode(.alwaysOriginal)
            AppDelegate.shared().registerForPushNotifications()
            LRServer.shared.addFavorite(restaurant, completion: {
                DispatchQueue.main.async {
                    //           self.updateTabVC()
                }
            })
        }
        
        NotificationCenter.default.post(name: Notification.Name.favoritesDidChange, object: nil)
    }
    
    @IBAction func goBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func didConfirmReservation(_ sender: ConfirmReservationViewController, _ tableId: Int) {
        showIndicator("Checking Availability", 2.0, completion: {
            LRServer.shared.isAvailable(tableId) {(available: Bool) in
                DispatchQueue.main.async {
                    self.hideIndicator()
                    if available
                    {
                        self.delegate?.reservationIsAvailable(self, tableId, true)
                    }
                    else
                    {
                        self.delegate?.reservationIsAvailable(self, -1, false)
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
}

class ReservationTracker
{
    var restId = 0
    var timeStr = ""
}
