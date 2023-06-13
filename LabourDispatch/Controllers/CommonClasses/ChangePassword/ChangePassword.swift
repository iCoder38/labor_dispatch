//
//  ChangePassword.swift
//  Alien Broccoli
//
//  Created by Apple on 30/09/20.
//

import UIKit
import Alamofire

class ChangePassword: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CHANGE PASSWORD"
            lblNavigationTitle.textColor = .black
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton!
    
    @IBOutlet weak var txtCurrentPassword:UITextField! {
        didSet {
            txtCurrentPassword.layer.cornerRadius = 6
            txtCurrentPassword.clipsToBounds = true
            txtCurrentPassword.setLeftPaddingPoints(40)
            txtCurrentPassword.layer.borderColor = UIColor.clear.cgColor
            txtCurrentPassword.layer.borderWidth = 0.8
            txtCurrentPassword.backgroundColor = .white
            txtCurrentPassword.placeholder = "Current Password"
        }
    }
    
    @IBOutlet weak var txtNewPassword:UITextField! {
        didSet {
            txtNewPassword.layer.cornerRadius = 6
            txtNewPassword.clipsToBounds = true
            txtNewPassword.setLeftPaddingPoints(40)
            txtNewPassword.layer.borderColor = UIColor.clear.cgColor
            txtNewPassword.layer.borderWidth = 0.8
            txtNewPassword.backgroundColor = .white
            txtNewPassword.placeholder = "New Password"
        }
    }
    
    @IBOutlet weak var txtConfirmPassword:UITextField! {
        didSet {
            txtConfirmPassword.layer.cornerRadius = 6
            txtConfirmPassword.clipsToBounds = true
            txtConfirmPassword.setLeftPaddingPoints(40)
            txtConfirmPassword.layer.borderColor = UIColor.clear.cgColor
            txtConfirmPassword.layer.borderWidth = 0.8
            txtConfirmPassword.backgroundColor = .white
            txtConfirmPassword.placeholder = "Confirm Password"
        }
    }
    
    @IBOutlet weak var btnUpdatePassword:UIButton! {
        didSet {
            btnUpdatePassword.layer.cornerRadius = 6
            btnUpdatePassword.clipsToBounds = true
            btnUpdatePassword.backgroundColor = APP_BASIC_COLOR
            btnUpdatePassword.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var lblHelloWelcome:UILabel! {
        didSet {
            lblHelloWelcome.text = "CHANGE PASSWORD"
            lblHelloWelcome.textColor = APP_BASIC_COLOR
        }
    }
    
    @IBOutlet weak var lblHelloWelcomeTitle2:UILabel! {
        didSet {
            lblHelloWelcomeTitle2.text = "Change You Account password."
            lblHelloWelcomeTitle2.textColor = APP_BASIC_COLOR
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnUpdatePassword.addTarget(self, action: #selector(validationBeforeChangePassword), for: .touchUpInside)
        
        // MARK:- VIEW UP WHEN CLICK ON TEXT FIELD -
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.txtNewPassword.delegate = self
        self.txtCurrentPassword.delegate = self
        self.txtConfirmPassword.delegate = self
        
        self.view.backgroundColor = .black
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            self.lblHelloWelcome.text = "Hello "+(person["fullName"] as! String)+" welcome!"
            
        }
        
        self.sideBarMenuClick()
    }
    
    // MARK:- KEYBOARD WILL SHOW -
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK:- KEYBOARD WILL HIDE -
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
        btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func validationBeforeChangePassword() {
        
        if self.txtCurrentPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("Current Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else if self.txtNewPassword.text == "" {
            
            let alert = UIAlertController(title: String("Error!"), message: String("New Password should not be Empty."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
             self.changePasswordWB()
        }
        
        
    }
    
    
    @objc func changePasswordWB() {
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = ChangePasswordW(action: "changePassword",
                                         userId: String(myString),
                                         oldPassword: String(txtCurrentPassword.text!),
                                         newPassword: String(txtNewPassword.text!))
        
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
                        
                         var strSuccess2 : String!
                         strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                
                                self.txtCurrentPassword.text = ""
                                self.txtNewPassword.text = ""
                                self.txtConfirmPassword.text = ""
                                
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
    
}
