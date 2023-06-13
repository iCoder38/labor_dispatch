//
//  CAddNewAddress.swift
//  Alien Broccoli
//
//  Created by Apple on 03/10/20.
//

import UIKit

import  Alamofire

// MARK:- LOCATION -
import CoreLocation

class CAddNewAddress: UIViewController, CLLocationManagerDelegate {

    let cellReuseIdentifier = "cAddNewAddressTableCell"
    
    let locationManager = CLLocationManager()
    
    var editOrAdd:String!
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    // address line is
    var strAddressLineIs:String!
    
    var dictGetSavedAddressForEdit:NSDictionary!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ADDRESS"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            
        }
    }
    
    @IBOutlet weak var btnDeleteAddress:UIButton! {
        didSet {
            btnDeleteAddress.tintColor = .red
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
             self.tbleView.delegate = self
             self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btnDeleteAddress.addTarget(self, action: #selector(deleteAddressClickMethod), for: .touchUpInside)
        
        self.tbleView.separatorColor = .clear
        
        self.strSaveLatitude = "0"
        self.strSaveLongitude = "0"
        
        
        // print(dictGetSavedAddressForEdit as Any)
        
        if editOrAdd == "editAddress" {
            
            self.btnDeleteAddress.isHidden = false
            self.fetchAndSaveAddressValueFromServer()
        } else {
            
            self.btnDeleteAddress.isHidden = true
            self.iAmHereForLocationPermission()
        }
        
        
        
        
    }
    
    @objc func fetchAndSaveAddressValueFromServer() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CAddNewAddressTableCell
        
        

        cell.txtFirstName.text      = (dictGetSavedAddressForEdit["firstName"] as! String)
        cell.txtLastName.text       = (dictGetSavedAddressForEdit["lastName"] as! String)
        cell.txtMobileNumber.text   = (dictGetSavedAddressForEdit["mobile"] as! String)
        cell.txtaddressLine1.text   = (dictGetSavedAddressForEdit["address"] as! String)
        cell.txtaddressLine2.text   = (dictGetSavedAddressForEdit["addressLine2"] as! String)
        cell.txtCity.text           = (dictGetSavedAddressForEdit["City"] as! String)
        cell.txtPinCode.text        = (dictGetSavedAddressForEdit["Zipcode"] as! String)
        cell.txtCountry.text        = (dictGetSavedAddressForEdit["country"] as! String)
        cell.txtState.text          = (dictGetSavedAddressForEdit["state"] as! String)
        cell.txtCompany.text        = (dictGetSavedAddressForEdit["deliveryType"] as! String)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
 
    // delete address pop up
    @objc func deleteAddressClickMethod() {
        
        let nameWithAddress = "Name : "+(dictGetSavedAddressForEdit["firstName"] as! String)+" "+(dictGetSavedAddressForEdit["lastName"] as! String)+"\nAddress : "+(dictGetSavedAddressForEdit["address"] as! String)+" "+(dictGetSavedAddressForEdit["addressLine2"] as! String)
        
        let alert = UIAlertController(title: String("Delete this address ?"), message: String(nameWithAddress), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.default, handler: { action in
             
            self.deleteThisAddress()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.destructive, handler: { action in
             
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func iAmHereForLocationPermission() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
              
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                self.strSaveLatitude = "0"
                self.strSaveLongitude = "0"
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                          
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                      
            @unknown default:
                break
            }
        }
    }
    
    // MARK:- GET CUSTOMER LOCATION -
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        // self.tbleView.delegate = self
        // self.tbleView.dataSource = self
        
         let indexPath = IndexPath.init(row: 0, section: 0)
         let cell = self.tbleView.cellForRow(at: indexPath) as! CAddNewAddressTableCell
        
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        location.fetchCityAndCountry { city, country, zipcode,localAddress,localAddressMini,locality, error in
            guard let city = city, let country = country,let zipcode = zipcode,let localAddress = localAddress,let localAddressMini = localAddressMini,let locality = locality, error == nil else { return }
            
            self.strSaveCountryName     = country
            self.strSaveStateName       = city
            self.strSaveZipcodeName     = zipcode
            
            self.strSaveLocalAddress     = localAddress
            self.strSaveLocality         = locality
            self.strSaveLocalAddressMini = localAddressMini
            
            //print(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            
            let doubleLat = locValue.latitude
            let doubleStringLat = String(doubleLat)
            
            let doubleLong = locValue.longitude
            let doubleStringLong = String(doubleLong)
            
            self.strSaveLatitude = String(doubleStringLat)
            self.strSaveLongitude = String(doubleStringLong)
            
            // print("local address ==> "+localAddress as Any) // south west delhi
            // print("local address mini ==> "+localAddressMini as Any) // new delhi
            // print("locality ==> "+locality as Any) // sector 10 dwarka
            
            // print(self.strSaveCountryName as Any) // india
            // print(self.strSaveStateName as Any) // new delhi
            // print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            
            self.tbleView.reloadData()
            
            cell.txtaddressLine1.text = "temp"//String(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            cell.txtCountry.text = String(self.strSaveCountryName)
            cell.txtState.text = String(self.strSaveStateName)
            cell.txtPinCode.text = String(self.strSaveZipcodeName)
            cell.txtCity.text = String(locality)
            
            // self.findMyStateTaxWB()
        }
    }
    
    // MARK:- VALIDATINO BEFORE SUBMIT -
    @objc func validationBeforeAddorEditNewAddress() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CAddNewAddressTableCell
        
        if cell.txtFirstName.text == "" {
            
            self.errorPopUp(strTitle: "First Name", strMessage: "First name field")
            
        } else if cell.txtLastName.text == "" {
            
            self.errorPopUp(strTitle: "Last Name", strMessage: "Last name field")
            
        } else if cell.txtMobileNumber.text == "" {
            
            self.errorPopUp(strTitle: "Mobile Number", strMessage: "Mobile Number field")
            
        } else if cell.txtaddressLine1.text == "" {
            
            self.errorPopUp(strTitle: "Address Line", strMessage: "Address Line field")
            
        } else if cell.txtaddressLine2.text == "" {
            
            self.errorPopUp(strTitle: "Address Line 2", strMessage: "Address Line 2 field")
            
        } else if cell.txtCity.text == "" {
            
            self.errorPopUp(strTitle: "City", strMessage: "City field")
            
        } else if cell.txtPinCode.text == "" {
            
            self.errorPopUp(strTitle: "Pincode", strMessage: "Pincode field")
            
        } else if cell.txtCountry.text == "" {
            
            self.errorPopUp(strTitle: "Coutry", strMessage: "Country field")
            
        } else if cell.txtState.text == "" {
            
            self.errorPopUp(strTitle: "State", strMessage: "State field")
            
        } else if cell.txtCompany.text == "" {
            
            self.errorPopUp(strTitle: "Company", strMessage: "Company Name")
            
        } else {
        
            if editOrAdd == "editAddress" {
                
                self.editAddress()
            } else {
                
                self.addNewAddress()
            }
            
            
            
        }
        
    }
    
    @objc func errorPopUp(strTitle:String,strMessage:String) {
    
        let alert = UIAlertController(title: String(strTitle), message: String(strMessage)+" should not be empty", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
             
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK:- WEBSERVICE ( ADD NEW ADDRESS ) -
    @objc func addNewAddress() {
         
        /*
         [action] => editaddress
         [userId] => 71
         [addressId] => 17
         */
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! CAddNewAddressTableCell
                
            // if cell.txtaddressLine2.text == "" {
                
                // self.strAddressLineIs = String(cell.txtaddressLine1.text!)
            // } else {
                
                // self.strAddressLineIs = String(cell.txtaddressLine1.text!)+String(cell.txtaddressLine2.text!)
            // }
            
            let params = AddNewAddress(action: "addaddress",
                                       userId: String(myString),
                                       firstName: String(cell.txtFirstName.text!),
                                       lastName: String(cell.txtLastName.text!),
                                       mobile: String(cell.txtMobileNumber.text!),
                                       address: String(cell.txtaddressLine1.text!),
                                       addressLine2:String(cell.txtaddressLine2.text!),
                                       City: String(cell.txtCity.text!),
                                       state: String(cell.txtState.text!),
                                       country: String(cell.txtCountry.text!),
                                       Zipcode: String(cell.txtPinCode.text!),
                                       deliveryType: String(cell.txtCompany.text!))
            
            AF.request(BASE_URL_ALIEN_BROCCOLI,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                             print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("Success") {
                                print("yes")
                               
                                ERProgressHud.sharedInstance.hide()
                                
                            } else {
                                print("no")
                                ERProgressHud.sharedInstance.hide()
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                                
                            }
                            
                        case let .failure(error):
                            print(error)
                            ERProgressHud.sharedInstance.hide()
                            
                            Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
    }
    
    // MARK:- WEBSERVICE ( EDIT ADDRESS ) -
    @objc func editAddress() {
         
        /*
         [action] => editaddress
         [userId] => 71
         [addressId] => 17
         */
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
             
            
            let x2 : Int = (dictGetSavedAddressForEdit["addressId"] as! Int)
            let myString2 = String(x2)
            
            let indexPath = IndexPath.init(row: 0, section: 0)
            let cell = self.tbleView.cellForRow(at: indexPath) as! CAddNewAddressTableCell
                
            

            let params = EditAddress(action: "editaddress",
                                       userId: String(myString),
                                       addressId: String(myString2),
                                       firstName: String(cell.txtFirstName.text!),
                                       lastName: String(cell.txtLastName.text!),
                                       mobile: String(cell.txtMobileNumber.text!),
                                       address: String(cell.txtaddressLine1.text!),
                                       addressLine2:String(cell.txtaddressLine2.text!),
                                       City: String(cell.txtCity.text!),
                                       state: String(cell.txtState.text!),
                                       country: String(cell.txtCountry.text!),
                                       Zipcode: String(cell.txtPinCode.text!),
                                       deliveryType: String(cell.txtCompany.text!))
            
            // print(params as Any)
            AF.request(BASE_URL_ALIEN_BROCCOLI,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                             print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                               
                                ERProgressHud.sharedInstance.hide()
                                
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                print("no")
                                ERProgressHud.sharedInstance.hide()
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                                
                            }
                            
                        case let .failure(error):
                            print(error)
                            ERProgressHud.sharedInstance.hide()
                            
                            Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
    }
    
    
    // MARK:- WEBSERVICE ( DELETE THIS ADDRESS ) -
    @objc func deleteThisAddress() {
       
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Deleting...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
             
            let x2 : Int = (dictGetSavedAddressForEdit["addressId"] as! Int)
            let myString2 = String(x2)
            
            let params = DeleteThisAddress(action: "deleteaddress",
                                           userId: String(myString),
                                           addressId: String(myString2))
            
            // print(params as Any)
            AF.request(BASE_URL_ALIEN_BROCCOLI,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                        // debugPrint(response.result)
                        
                        switch response.result {
                        case let .success(value):
                            
                            let JSON = value as! NSDictionary
                             // print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            
                            if strSuccess == String("success") {
                                print("yes")
                               
                                ERProgressHud.sharedInstance.hide()
                                
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                print("no")
                                ERProgressHud.sharedInstance.hide()
                                
                                var strSuccess2 : String!
                                strSuccess2 = JSON["msg"]as Any as? String
                                
                                Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                                
                            }
                            
                        case let .failure(error):
                            print(error)
                            ERProgressHud.sharedInstance.hide()
                            
                            Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                        }
                }
            
            }
    }
}


extension CAddNewAddress: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // arrListOfAllMyOrders.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:CAddNewAddressTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CAddNewAddressTableCell
          
        if editOrAdd == "editAddress" {
            
            cell.btnSaveAddress.setTitle("Edit Address", for: .normal)
        } else {
            
            cell.btnSaveAddress.setTitle("Save Address", for: .normal)
        }
        
        cell.btnSaveAddress.addTarget(self, action: #selector(validationBeforeAddorEditNewAddress), for: .touchUpInside)
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 1000
    }
    
}

extension CAddNewAddress: UITableViewDelegate {
    
}
