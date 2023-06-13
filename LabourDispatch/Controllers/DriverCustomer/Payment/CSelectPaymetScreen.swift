//
//  CSelectPaymetScreen.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit
import Stripe
import Alamofire
import SwiftyJSON

// MARK:- LOCATION -
import CoreLocation

class CSelectPaymetScreen: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    let cellReuseIdentifier = "cSelectPaymentScreenTableCell"
    
    let locationManager = CLLocationManager()
    
    var strTotalAmountToPay:String!
    
    var strWhatCardIam:String!
    
    var strGetName:String!
    var strGetPhoneNumber:String!
    var strGetAddress:String!
    var strGetZipcode:String!
    var strGetState:String!
    var strGetCountry:String!
    
    var addInitialMutable:NSMutableArray = []
    var fullArrayProductDetails:NSArray! // NSMutableArray = []
    
    var cardTypeIs:String!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "PAYMENT"
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            // btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tbleView:UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
        }
    }
    
    @IBOutlet weak var lblCardNumberHeading:UILabel!
    @IBOutlet weak var lblEXPDate:UILabel!
    
    @IBOutlet weak var lblPayableAmount:UILabel!
    
    // set values and send to server
    var paymentProductName:String!
    var paymentProductAddress:String!
    var paymentProductState:String!
    var paymentProductCity:String!
    var paymentProductZipcode:String!
    var paymentProductPhoneNumber:String!
    
    var arrayAddDataOnMutArrayToSendToOurLocalServer:NSMutableArray = []
    
    // automatic detect location
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    @IBOutlet weak var btnmakePayment:UIButton! {
        didSet {
            btnmakePayment.backgroundColor = NAVIGATION_BACKGROUND_COLOR
            btnmakePayment.setTitle("PAY NOW", for: .normal)
            btnmakePayment.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var viewCard:UIView! {
        didSet {
            viewCard.backgroundColor = NAVIGATION_BACKGROUND_COLOR // UIColor.init(red: 34.0/255.0, green: 72.0/255.0, blue: 104.0/255.0, alpha: 1)
            viewCard.layer.cornerRadius = 6
            viewCard.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgCardImage:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // print(strTotalAmountToPay as Any)
        // print(fullArrayProductDetails[0] as Any)
        // print(fullArrayProductDetails.count as Any)
        
        self.strSaveLatitude = "0"
        self.strSaveLongitude = "0"
        
        
        // name
        // print(fullArrayProductDetails[0] as Any)
        let item = self.fullArrayProductDetails[0] as? [String:Any]
        // print(item as Any)
        
        if (item!["productName"] as! String) == "" {
            
            self.paymentProductName = ""
        } else {
            self.paymentProductName = (item!["productName"] as! String)
        }
        
        if (item!["productAddress"] as! String) == "" {
            
            self.paymentProductAddress = ""
        } else {
            self.paymentProductAddress = (item!["productAddress"] as! String)
        }
        
        if (item!["productState"] as! String) == "" {
            
            self.paymentProductState = ""
        } else {
            self.paymentProductState = (item!["productState"] as! String)
        }
        
        if (item!["productZipcode"] as! String) == "" {
            
            self.paymentProductZipcode = ""
        } else {
            self.paymentProductZipcode = (item!["productZipcode"] as! String)
        }
        
        if (item!["productCity"] as! String) == "" {
            
            self.paymentProductCity = ""
        } else {
            self.paymentProductCity = (item!["productCity"] as! String)
        }
        
        if (item!["productPhoneNumber"] as! String) == "" {
            
            self.paymentProductPhoneNumber = ""
        } else {
            self.paymentProductPhoneNumber = (item!["productPhoneNumber"] as! String)
        }
        
        // print(paymentProductName as Any)
        // print(paymentProductAddress as Any)
        // print(paymentProductState as Any)
        // print(paymentProductCity as Any)
        // print(paymentProductPhoneNumber as Any)
        
         // product details
        // print(fullArrayProductDetails as Any)
        
        // print(fullArrayProductDetails)
        
        /*
        
         [{"productId":"21","price":"80.0","Quantity":"1"}]
         
         */
        
        /*
         productAddress = "";
         productCity = "";
         productId = 20;
         productImage = "";
         productName = "Green Juice with CBD";
         productPrice = 34;
         productQuantity = 2;
         productState = "";
         productZipcode = "";
         */
        
        for productDetailsForPayment in 0..<self.fullArrayProductDetails.count {
            
            let item = self.fullArrayProductDetails[productDetailsForPayment] as? [String:Any]
            // print(item as Any)
            
            if item!["productPrice"] as! String == "" {
                
                // no add on mut array
            } else {
                
                let myDictionary: [String:String] = [
                    
                    "productId":(item!["productId"] as! String),
                    "price":(item!["productPrice"] as! String),
                    "Quantity":(item!["productQuantity"] as! String)
                    
                ]
                
                var res = [[String: String]]()
                res.append(myDictionary)
                
                self.arrayAddDataOnMutArrayToSendToOurLocalServer.addObjects(from: res)
                
                // productPrice
                // self.arrayAddDataOnMutArrayToSendToOurLocalServer.add(item!["productPrice"] as! String)
            }
        }
        
        
        // print(self.arrayAddDataOnMutArrayToSendToOurLocalServer as Any)
        
        
        
        self.lblPayableAmount.text = "Total Payable Amount : $ "+self.strTotalAmountToPay
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(CSelectPaymetScreen.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        self.btnBack.addTarget(self, action: #selector(sideBarMenuClick), for: .touchUpInside)
        
        self.btnmakePayment.addTarget(self, action: #selector(firstCheckValidation), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.iAmHereForLocationPermission()
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func sideBarMenuClick() {
         self.navigationController?.popViewController(animated: true)
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
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDCompleteAddressDetailsTableCell
        
        
        
        
        
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
            
            print("local address ==> "+localAddress as Any) // south west delhi
            print("local address mini ==> "+localAddressMini as Any) // new delhi
            print("locality ==> "+locality as Any) // sector 10 dwarka
            
            print(self.strSaveCountryName as Any) // india
            print(self.strSaveStateName as Any) // new delhi
            print(self.strSaveZipcodeName as Any) // 110075
            
            //MARK:- STOP LOCATION -
            self.locationManager.stopUpdatingLocation()
            
            // cell.txtAddress.text = String(self.strSaveLocality+" "+self.strSaveLocalAddress+" "+self.strSaveLocalAddressMini)
            // cell.txtCountry.text = String(self.strSaveCountryName)
            // cell.txtState.text = String(self.strSaveStateName)
            // cell.txtZipcode.text = String(self.strSaveZipcodeName)
            // cell.txtCity.text = String(locality)
            
            // self.findMyStateTaxWB()
        }
    }
    
    @objc func firstCheckValidation() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        if cell.txtCardNumber.text == "" {
            let alert = UIAlertController(title: "Card Number", message: "Card number should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtExpDate.text == "" {
            let alert = UIAlertController(title: "Exp Month", message: "Expiry Month should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else if cell.txtCVV.text == "" {
            let alert = UIAlertController(title: "Security Code", message: "Security Code should not be blank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            
            self.fetchStripeToken()
        }
    }
    
    
    
    // MARK:- FETCH STRIPE TOKEN -
    @objc func fetchStripeToken() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        
        let fullNameArr = cell.txtExpDate.text!.components(separatedBy: "/")

        let expMonth    = fullNameArr[0]
        let expYear = fullNameArr[1]
        
        // print(expMonth as Any)
        // print(expYear as Any)
        
        let cardParams = STPCardParams()
        
        cardParams.number       = String(cell.txtCardNumber.text!)
        cardParams.expMonth     = UInt(expMonth)!
        cardParams.expYear      = UInt(expYear)!
        cardParams.cvc          = String(cell.txtCVV.text!)
        
        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let token = token else {
                // Handle the error
                // print(error as Any)
                // print(error?.localizedDescription as Any)
                ERProgressHud.sharedInstance.hide()
                
                let alert = UIAlertController(title: "Error", message: String(error!.localizedDescription), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
                
                return
            }
            let tokenID = token.tokenId
            print(tokenID)
              
            self.makePaymentForThisDeliveryWB(strStripeTokenIs: tokenID)
        }
        
        
    }
    
    @objc func makePaymentForThisDeliveryWB(strStripeTokenIs:String) {
        
        // print(strStripeTokenIs as Any)
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
        
        // MakePaymentOfOrders
        
        /*
        [action] => addpurchese
        [userId] => 70
        [productDetails] => [{"productId":"21","price":"80.0","Quantity":"1"}]
        [totalAmount] => 80.0
        [ShippingName] => Deepak
        [ShippingAddress] => 344, Chandralok Colony, chandarlok, Meerut, Uttar Pradesh 250002, IndiMeerut
        [ShippingCity] => Meerut
        [ShippingState] => Uttar pradesh
        [ShippingZipcode] => 250002
        [ShippingPhone] => 7906703537
        [transactionId] => tok_1HYrzvBnk7ygV50qPCfouLDp
        [latitude] => 28.5870856
        [longitude] => 77.0606002
        */
        
        // convert array into JSONSerialization
        let paramsArray = self.arrayAddDataOnMutArrayToSendToOurLocalServer
        let paramsJSON = JSON(paramsArray)
        let paramsString = paramsJSON.rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)!
        
        
        
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
          
            let params = MakePaymentOfOrders(action: "addpurchese",
                                             userId: String(myString),
                                             productDetails: paramsString,
                                             totalAmount: String(self.strTotalAmountToPay),
                                             ShippingName: String(self.paymentProductName),
                                             ShippingAddress: String(self.paymentProductAddress),
                                             ShippingCity: String(self.paymentProductCity),
                                             ShippingState: String(self.paymentProductState),
                                             ShippingZipcode: String(self.paymentProductZipcode),
                                             ShippingPhone: String(self.paymentProductPhoneNumber),
                                             transactionId: String(strStripeTokenIs),
                                             latitude: String(self.strSaveLatitude),
                                             longitude: String(self.strSaveLongitude),
                                             cardType:String(strWhatCardIam)
                // strWhatCardIam
            )
        
             
            
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
                        
                         // var strSuccess2 : String!
                         // strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            // ERProgressHud.sharedInstance.hide()
                           
                            self.deleteAllCart()
                            
                            
                            
                            
                            
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
    
    // MARK:- WEBSERVICE ( CLEAR ALL CART ) -
    @objc func deleteAllCart() {
        // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = DeleteAllCartItems(action: "deleteallcarts",
                                        userId: String(myString))
        
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
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            let alert = UIAlertController(title: String("Success"), message: String("Successfully purchased"), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                
                                self.pushToDashbaord()
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                            
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
    
    // MARK:- PUSH -
    @objc func pushToDashbaord() {
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                          
            if person["role"] as! String == "Driver" {
                                              
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DDashbaordId") as? DDashbaord
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            } else {
                                                  
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId") as? CDashboard
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
            }
                                              
        }
    }
    
}


//MARK:- TABLE VIEW -
extension CSelectPaymetScreen: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CSelectPaymentScreenTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CSelectPaymentScreenTableCell
        //
        cell.backgroundColor = .white
      
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        cell.txtCardNumber.delegate = self
        cell.txtExpDate.delegate = self
        cell.txtCVV.delegate = self
        
        cell.txtCardNumber.addTarget(self, action: #selector(CSelectPaymetScreen.textFieldDidChange(_:)), for: .editingChanged)
        cell.txtExpDate.addTarget(self, action: #selector(CSelectPaymetScreen.textFieldDidChange2(_:)), for: .editingChanged)
        
        return cell
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
            
         self.lblCardNumberHeading.text! = cell.txtCardNumber.text!
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
            
         self.lblEXPDate.text! = cell.txtExpDate.text!
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! CSelectPaymentScreenTableCell
        
        if textField == cell.txtCardNumber {
            
            let first2 = String(self.lblCardNumberHeading.text!.prefix(2))
            
            if first2.count == 2 {
                // print("yes")
                
                let first3 = String(self.lblCardNumberHeading.text!.prefix(2))
                // print(first3 as Any)
                
                if first3 == "34" { // amex
                    self.imgCardImage.image = UIImage(named: "amex")
                    self.strWhatCardIam = "amex"
                } else if first3 == "37" { // amex
                    self.imgCardImage.image = UIImage(named: "amex")
                    self.strWhatCardIam = "amex"
                } else if first3 == "51" { // master
                    self.imgCardImage.image = UIImage(named: "mastercard")
                    self.strWhatCardIam = "master"
                } else if first3 == "55" { // master
                    self.imgCardImage.image = UIImage(named: "mastercard")
                    self.strWhatCardIam = "master"
                }  else if first3 == "42" { // visa
                    self.imgCardImage.image = UIImage(named: "visa")
                    self.strWhatCardIam = "visa"
                } else if first3 == "65" { // discover
                    self.imgCardImage.image = UIImage(named: "discover")
                    self.strWhatCardIam = "discover"
                } else {
                    self.imgCardImage.image = UIImage(named: "ccCard")
                    self.strWhatCardIam = "none"
                }
                
            } else {
                // print("no")
                self.imgCardImage.image = UIImage(named: "ccCard")
            }
            
            /*
            if self.lblCardNumberHeading.text!.count+1 == 2 {
                // print("check card")
                
            } else {
                // print("do not check card")
            }
            */
            
            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                    return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            // print(self.strWhatCardIam as Any)
            if self.strWhatCardIam == "amex" {
                return count <= 15
            } else {
                return count <= 16
            }
            
            
        }
        
        if textField == cell.txtExpDate {
            if string == "" {
                return true
            }

            
            let currentText = textField.text! as NSString
            let updatedText = currentText.replacingCharacters(in: range, with: string)

            textField.text = updatedText
            let numberOfCharacters = updatedText.count
            
            if numberOfCharacters == 2 {
                textField.text?.append("/")
            }
            self.lblEXPDate.text! = cell.txtExpDate.text!
        }
        
       if textField == cell.txtCVV {
           
           guard let textFieldText = textField.text,
               let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                   return false
           }
           let substringToReplace = textFieldText[rangeOfTextToReplace]
           let count = textFieldText.count - substringToReplace.count + string.count
           return count <= 3
       }
        
        return false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
}

extension CSelectPaymetScreen: UITableViewDelegate {
    
}



