//
//  Registration.swift
//  TheGlobalHair
//
//  Created by Apple on 18/11/20.
//

import UIKit
import Alamofire

// MARK:- LOCATION -
import CoreLocation

class Registration: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

// ***************************************************************** // nav
        
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_TITLE_COLOR
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Registraiton"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
        
// ***************************************************************** // nav
    
    var profilePart:String!
    
    var myDeviceTokenIs:String!
    
    let locationManager = CLLocationManager()
    
    // MARK:- SAVE LOCATION STRING -
    var strSaveLatitude:String!
    var strSaveLongitude:String!
    var strSaveCountryName:String!
    var strSaveLocalAddress:String!
    var strSaveLocality:String!
    var strSaveLocalAddressMini:String!
    var strSaveStateName:String!
    var strSaveZipcodeName:String!
    
    @IBOutlet weak var viewBGloginDetails:UIView! {
        didSet {
            viewBGloginDetails.backgroundColor = .black
        }
    }
    
    @IBOutlet weak var btnUpperSignIn:UIButton! {
        didSet {
            btnUpperSignIn.backgroundColor = .clear
            btnUpperSignIn.setTitle("Sign In", for: .normal)
            btnUpperSignIn.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var btnUpperSignUp:UIButton! {
        didSet {
            btnUpperSignUp.backgroundColor = .clear
            btnUpperSignUp.setTitle("Sign Up", for: .normal)
            btnUpperSignUp.setTitleColor(APP_BASIC_COLOR, for: .normal)
            
            let lineView = UIView(frame: CGRect(x: 0, y: btnUpperSignUp.frame.size.height, width: btnUpperSignUp.frame.size.width, height: 2))
            lineView.backgroundColor = APP_BASIC_COLOR
            btnUpperSignUp.addSubview(lineView)
        }
    }
    
    @IBOutlet weak var txtUsername:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtUsername,
                              tfName: txtUsername.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Username")
        }
    }
    
    @IBOutlet weak var txtFirstName:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtFirstName,
                              tfName: txtFirstName.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "First Name")
        }
    }
    
    @IBOutlet weak var txtLastName:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtLastName,
                              tfName: txtLastName.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Last Name")
         }
    }
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtEmail,
                              tfName: txtEmail.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .emailAddress,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Email Address")
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtPassword,
                              tfName: txtPassword.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Password")
        }
    }
    
    @IBOutlet weak var txtAddress:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtAddress,
                              tfName: txtAddress.text!,
                              tfCornerRadius: 6,
                              tfpadding: 40,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Address")
        }
    }
    
    @IBOutlet weak var txtPhone:UITextField! {
        didSet {
            Utils.textFieldUI(textField: txtPhone,
                              tfName: txtPhone.text!,
                              tfCornerRadius: 6,
                              tfpadding: 44,
                              tfBorderWidth: 0.8,
                              tfBorderColor: .clear,
                              tfAppearance: .dark,
                              tfKeyboardType: .phonePad,
                              tfBackgroundColor: .white,
                              tfPlaceholderText: "Phone Number")
        }
    }
    
    @IBOutlet weak var btnCheckUncheck:UIButton!
    
    @IBOutlet weak var btnAlreadyHaveAnAccount:UIButton! {
        didSet {
            btnAlreadyHaveAnAccount.setTitle("Already have an account - Sign In", for: .normal)
            btnAlreadyHaveAnAccount.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnSignUp:UIButton! {
        didSet {
            btnSignUp.backgroundColor = BUTTON_COLOR_BLUE
            btnSignUp.layer.cornerRadius = 6
            btnSignUp.setTitleColor(.white, for: .normal)
            btnSignUp.setTitle("Sign Up", for: .normal)
        }
    }
    
    @IBOutlet weak var lblAreYouOverTheAge:UILabel! {
        didSet {
            lblAreYouOverTheAge.textColor = APP_BASIC_COLOR
            lblAreYouOverTheAge.text =  "Are you over the age of 18+ year ?"
        }
    }
    
// ***************************************************************** //
// ***************************************************************** //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.txtUsername.delegate = self
        self.txtFirstName.delegate = self
        self.txtLastName.delegate = self
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        self.txtAddress.delegate = self
        
        self.btnUpperSignIn.addTarget(self, action: #selector(upperSignInClickMethod), for: .touchUpInside)
        self.btnAlreadyHaveAnAccount.addTarget(self, action: #selector(upperSignInClickMethod), for: .touchUpInside)
        
        self.btnSignUp.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.btnCheckUncheck.setImage(UIImage(named: "uncheck3"), for: .normal)
        self.btnCheckUncheck.tag = 0
        self.btnCheckUncheck.addTarget(self, action: #selector(checkUncheckClickMethod), for: .touchUpInside)
        self.btnSignUp.isUserInteractionEnabled = false
        self.btnSignUp.backgroundColor = .lightGray
        self.btnSignUp.setTitleColor(.black, for: .normal)
        
        // self.iAmHereForLocationPermission()
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
        // let cell = self.tbleView.cellForRow(at: indexPath) as! PDBagPurchaseTableCell
        
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
            
            
            
            // self.findMyStateTaxWB()
        }
    }
    
    @objc func upperSignInClickMethod() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func checkUncheckClickMethod() {
        if self.btnCheckUncheck.tag == 1 {
            
            self.btnSignUp.isUserInteractionEnabled = false
            self.btnSignUp.backgroundColor = .lightGray
            self.btnSignUp.setTitleColor(.black, for: .normal)
            self.btnCheckUncheck.setImage(UIImage(named: "uncheck3"), for: .normal)
            self.btnCheckUncheck.tag = 0
            
        } else {
            
            self.btnSignUp.isUserInteractionEnabled = true
            self.btnSignUp.backgroundColor = BUTTON_COLOR_BLUE
            self.btnSignUp.setTitleColor(.white, for: .normal)
            self.btnCheckUncheck.setImage(UIImage(named: "uncheck2"), for: .normal)
            self.btnCheckUncheck.tag = 1
            
        }
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: false)
    }
    
    // MARK:- KEYBOARD WILL SHOW -
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    // MARK:- KEYBOARD WILL HIDE -
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @objc func signUpClickMethod() {
        
        if self.profilePart == "Member" {
            
            self.signUpValidationCheck()
            
        } else {
        
            self.signUpValidationCheck()
            
            // let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteProfileId") as? CompleteProfile
            // self.navigationController?.pushViewController(push!, animated: true)
            
        }
        
    }
    
    
    // MARK:- CHECK VALIDATION BEFORE REGISTRATION -
    @objc func signUpValidationCheck() {
        if self.txtUsername.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Name should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtFirstName.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("First Name should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtLastName.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Last Name should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtEmail.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Email should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtPassword.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtPhone.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Phone should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else if self.txtAddress.text! == "" {
            let alert = UIAlertController(title: String("Error!"), message: String("Address should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            // MARK:- CALL WEBSERVICE OF SIGN UP WHEN TEXT FIELDS IS NOT EMPTY -
             self.registration()
        }
    }
    
    
    // MARK:- WEBSERVICE ( REGISTRATION ) -
    @objc func registration() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        
        // Create UserDefaults
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "deviceFirebaseToken") {
            self.myDeviceTokenIs = myString

        }
        else {
            self.myDeviceTokenIs = "111111111111111111111"
        }
        
        self.view.endEditing(true)
        
        let params = FullRegistration(action: "registration",
                                      username: String(txtUsername.text!),
                                      email: String(txtEmail.text!),
                                      password: String(txtPassword.text!),
                                      contactNumber: String(txtPhone.text!),
                                      device: "iOS",
                                      deviceToken: String(myDeviceTokenIs),
                                      role: String(profilePart),
                                      fullName: String(txtFirstName.text!)+" "+String(txtLastName.text!),
                                      address: String(txtAddress.text!))
        
        print(params as Any)
        
        AF.request(BASE_URL_THE_GLOBAL_HAIR,
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
                           
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                             let defaults = UserDefaults.standard
                             defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            
                            // MARK:- PUSH -
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                            
                                if person["role"] as! String == "Seller" {
                                
                                     let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteProfileId") as? CompleteProfile
                                     self.navigationController?.pushViewController(settingsVCId!, animated: false)
                                    
                                } else {
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId") as? CDashboard
                                    self.navigationController?.pushViewController(push!, animated: true)
                                    
                                }
                                
                            }
                            
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
