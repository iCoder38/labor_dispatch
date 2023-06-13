//
//  Login.swift
//  TheGlobalHair
//
//  Created by Apple on 18/11/20.
//

import UIKit
import Alamofire

class Login: UIViewController, UITextFieldDelegate {

// ***************************************************************** // nav
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Login"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
// ***************************************************************** // nav
    
    var strLoginVia:String!
    
    var myDeviceTokenIs:String!
    
    var strCheckSubscriptionId:String!
    
    @IBOutlet weak var viewBGloginDetails:UIView! {
        didSet {
            viewBGloginDetails.backgroundColor = .black
        }
    }

    @IBOutlet weak var btnUpperSignIn:UIButton! {
        didSet {
            btnUpperSignIn.backgroundColor = .clear
            btnUpperSignIn.setTitle("Sign In", for: .normal)
            btnUpperSignIn.setTitleColor(APP_BASIC_COLOR, for: .normal)
            
            let lineView = UIView(frame: CGRect(x: 0, y: btnUpperSignIn.frame.size.height, width: btnUpperSignIn.frame.size.width, height: 2))
            lineView.backgroundColor = APP_BASIC_COLOR
            btnUpperSignIn.addSubview(lineView)
        }
    }
    
    @IBOutlet weak var btnUpperSignUp:UIButton! {
        didSet {
            btnUpperSignUp.backgroundColor = .clear
            btnUpperSignUp.setTitle("Sign Up", for: .normal)
            btnUpperSignUp.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblLoginMessage:UILabel! {
        didSet {
            lblLoginMessage.text = "Welcome to The Global Hair Network\nHello user, welcome back!"
            lblLoginMessage.textColor = APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var txtEmail:UITextField! {
        didSet {
            txtEmail.layer.cornerRadius = 6
            txtEmail.clipsToBounds = true
            txtEmail.setLeftPaddingPoints(40)
            txtEmail.layer.borderColor = UIColor.clear.cgColor
            txtEmail.layer.borderWidth = 0.8
            txtEmail.keyboardAppearance = .dark
            txtEmail.keyboardType = .default
            txtEmail.placeholder = "Username"
        }
    }
    
    @IBOutlet weak var txtPassword:UITextField! {
        didSet {
            txtPassword.layer.cornerRadius = 6
            txtPassword.clipsToBounds = true
            txtPassword.setLeftPaddingPoints(40)
            txtPassword.layer.borderColor = UIColor.clear.cgColor
            txtPassword.layer.borderWidth = 0.8
            txtPassword.isSecureTextEntry = true
            txtPassword.keyboardAppearance = .dark
        }
    }
    
    @IBOutlet weak var btnSignIn:UIButton! {
        didSet {
            btnSignIn.backgroundColor = BUTTON_COLOR_BLUE
            btnSignIn.layer.cornerRadius = 6
            btnSignIn.setTitleColor(.white, for: .normal)
            btnSignIn.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBOutlet weak var btnForgotPassword:UIButton! {
        didSet {
            btnForgotPassword.setTitle("Forgot Password", for: .normal)
            btnForgotPassword.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnDontHaveAnAccount:UIButton! {
        didSet {
            btnDontHaveAnAccount.setTitle("Don't have an account - Sign Up", for: .normal)
            btnDontHaveAnAccount.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    
// ***************************************************************** //
// ***************************************************************** //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        self.btnUpperSignUp.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
        self.btnDontHaveAnAccount.addTarget(self, action: #selector(signUpClickMethod), for: .touchUpInside)
        self.btnSignIn.addTarget(self, action: #selector(signInClickMethod), for: .touchUpInside)
        self.btnForgotPassword.addTarget(self, action: #selector(forgotPasswordClickMethod), for: .touchUpInside)
        
        self.txtEmail.delegate = self
        self.txtPassword.delegate = self
        
        // MARK:- DISMISS KEYBOARD WHEN CLICK OUTSIDE -
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func signUpClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationId") as? Registration
        push!.profilePart = strLoginVia
        self.navigationController?.pushViewController(push!, animated: false)
    }
    
    @objc func forgotPasswordClickMethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordId") as? ForgotPassword
        self.navigationController?.pushViewController(push!, animated: false)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
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
    
    @objc func signInClickMethod() {
        
        if self.strLoginVia == "Member" {
            
            if self.txtEmail.text! == "" {
                let alert = UIAlertController(title: String("Error!"), message: String("Email should not be Empty."), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                     
                }))
                self.present(alert, animated: true, completion: nil)
            } else if self.txtPassword.text! == "" {
                let alert = UIAlertController(title: String("Error!"), message: String("Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                     
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                if self.txtEmail.text!.isValidEmail() {
                    self.loginClickViaEmail()
                } else {
                    self.loginClick()
                }
            }
            
            
            
        } else {
         
            if self.txtEmail.text! == "" {
                let alert = UIAlertController(title: String("Error!"), message: String("Email should not be Empty."), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                     
                }))
                self.present(alert, animated: true, completion: nil)
            } else if self.txtPassword.text! == "" {
                let alert = UIAlertController(title: String("Error!"), message: String("Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                     
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                
                if self.txtEmail.text!.isValidEmail() {
                    self.loginClickViaEmail()
                } else {
                    self.loginClick()
                }
                
                //
                
            }
            
            
        }
         
    }

    @objc func loginClickViaEmail() {
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
        
        let forgotPasswordP = LoginParam(action: "login",
                                                    email:  String(txtEmail.text!),
                                         password: String(txtPassword.text!),
                                         deviceToken: String(self.myDeviceTokenIs),
                                         device: "iOS")
        
        AF.request(BASE_URL_THE_GLOBAL_HAIR,
                   method: .post,
                   parameters: forgotPasswordP,
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
                                print(person as Any)
                                
                                 let x : Int = person["subscriptionId"] as! Int
                                 let myString = String(x)
                                
                                /*
                                if dictGetDataForPayment["amount"] is String {
                                    print("Yes, it's a String")

                                    // self.strCheckSubscriptionId

                                } else if dictGetDataForPayment["amount"] is Int {
                                    print("It is Integer")
                                                
                                    let x2 : Int = (dictGetDataForPayment["amount"] as! Int)
                                    let myString2 = String(x2)
                                    self.lblPayableAmount.text = "Membership Amount : $ "+myString2
                                                
                                } else {
                                    print("i am number")
                                                
                                    let temp:NSNumber = dictGetDataForPayment["amount"] as! NSNumber
                                    let tempString = temp.stringValue
                                    self.lblPayableAmount.text = "Membership Amount : $ "+tempString
                                }
                                */
                                
                                if person["role"] as! String == "Seller" {
                                                           
                                    if person["country"] as! String == "" {
                                        
                                        let alert = UIAlertController(title: String("Profile Incomplete"), message: String("Your profile is not complete. Please complete your profile first."), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                             
                                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteProfileId") as? CompleteProfile
                                            self.navigationController?.pushViewController(push!, animated: true)
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                                             
                                            let defaults = UserDefaults.standard
                                            defaults.setValue("", forKey: "keyLoginFullData")
                                            defaults.setValue(nil, forKey: "keyLoginFullData")
                                            
                                        }))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                    } else if myString == "" {
                                        
                                        // check membership
                                        let alert = UIAlertController(title: String("Profile Incomplete"), message: String("Your profile is not complete. Please complete your profile first."), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                             
                                            // temp push

                                              let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipId") as? Membership
                                              self.navigationController?.pushViewController(push!, animated: true)
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                                             
                                            let defaults = UserDefaults.standard
                                            defaults.setValue("", forKey: "keyLoginFullData")
                                            defaults.setValue(nil, forKey: "keyLoginFullData")
                                            
                                        }))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else {
                                        
                                        // full done
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TGHNDashboardId") as? TGHNDashboard
                                        self.navigationController?.pushViewController(push!, animated: true)
                                        
                                    }
                                    
                                } else {
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId") as? CDashboard
                                    self.navigationController?.pushViewController(push!, animated: true)
                                    
                                }
                                
                            }
                            
                            // 10,196
                            
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
    
    @objc func loginClick() {
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
        
        let forgotPasswordP = LoginParamViaUsername(action: "login",
                                                    username:  String(txtEmail.text!),
                                         password: String(txtPassword.text!),
                                         deviceToken: String(self.myDeviceTokenIs),
                                         device: "iOS")
        
        AF.request(BASE_URL_THE_GLOBAL_HAIR,
                   method: .post,
                   parameters: forgotPasswordP,
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
                                print(person as Any)
                                
                                 let x : Int = person["subscriptionId"] as! Int
                                 let myString = String(x)
                                
                                /*
                                if dictGetDataForPayment["amount"] is String {
                                    print("Yes, it's a String")

                                    // self.strCheckSubscriptionId

                                } else if dictGetDataForPayment["amount"] is Int {
                                    print("It is Integer")
                                                
                                    let x2 : Int = (dictGetDataForPayment["amount"] as! Int)
                                    let myString2 = String(x2)
                                    self.lblPayableAmount.text = "Membership Amount : $ "+myString2
                                                
                                } else {
                                    print("i am number")
                                                
                                    let temp:NSNumber = dictGetDataForPayment["amount"] as! NSNumber
                                    let tempString = temp.stringValue
                                    self.lblPayableAmount.text = "Membership Amount : $ "+tempString
                                }
                                */
                                
                                if person["role"] as! String == "Seller" {
                                                           
                                    if person["country"] as! String == "" {
                                        
                                        let alert = UIAlertController(title: String("Profile Incomplete"), message: String("Your profile is not complete. Please complete your profile first."), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                             
                                            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteProfileId") as? CompleteProfile
                                            self.navigationController?.pushViewController(push!, animated: true)
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                                             
                                            let defaults = UserDefaults.standard
                                            defaults.setValue("", forKey: "keyLoginFullData")
                                            defaults.setValue(nil, forKey: "keyLoginFullData")
                                            
                                        }))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                        
                                        
                                    } else if myString == "" {
                                        
                                        // check membership
                                        let alert = UIAlertController(title: String("Profile Incomplete"), message: String("Your profile is not complete. Please complete your profile first."), preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                             
                                            // temp push

                                              let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MembershipId") as? Membership
                                              self.navigationController?.pushViewController(push!, animated: true)
                                            
                                        }))
                                        
                                        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                                             
                                            let defaults = UserDefaults.standard
                                            defaults.setValue("", forKey: "keyLoginFullData")
                                            defaults.setValue(nil, forKey: "keyLoginFullData")
                                            
                                        }))
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    } else {
                                        
                                        // full done
                                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TGHNDashboardId") as? TGHNDashboard
                                        self.navigationController?.pushViewController(push!, animated: true)
                                        
                                    }
                                    
                                } else {
                                    
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId") as? CDashboard
                                    self.navigationController?.pushViewController(push!, animated: true)
                                    
                                }
                                
                            }
                            
                            // 10,196
                            
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

extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
