//
//  ForgotPassword.swift
//  ExpressPlus
//
//  Created by Apple on 06/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

import Alamofire

class ForgotPassword: UIViewController {

    @IBOutlet weak var imglogo:UIImageView! {
        didSet {
            imglogo.layer.cornerRadius = 60
            imglogo.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "FORGOT PASSWORD"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var txtNewPassword:UITextField! {
        didSet {
            txtNewPassword.backgroundColor = .white
            txtNewPassword.layer.borderColor = UIColor.lightGray.cgColor
            txtNewPassword.layer.borderWidth = 0.8
            txtNewPassword.layer.cornerRadius = 6
            txtNewPassword.clipsToBounds = true
            
            let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 20))
            txtNewPassword.leftView = paddingView
            txtNewPassword.leftViewMode = .always
            
            txtNewPassword.attributedPlaceholder = NSAttributedString(string: "Enter Email Address",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
            
            txtNewPassword.keyboardType = .emailAddress
        }
    }
    
    @IBOutlet weak var btnUpdatePassword:UIButton! {
        didSet {
            btnUpdatePassword.backgroundColor = BUTTON_COLOR_BLUE
            btnUpdatePassword.layer.cornerRadius = 6
            btnUpdatePassword.clipsToBounds = true
            btnUpdatePassword.setTitleColor(.white, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        self.btnUpdatePassword.addTarget(self, action: #selector(forgotSubmitClickMethod), for: .touchUpInside)
        // self.sideBarMenuClick()
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    // MARK:- WEBSERVICE ( FORGOT PASSWORD ) -
    @objc func forgotSubmitClickMethod() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        let forgotPasswordP = ForgotPasswordWB(action: "forgotpassword",
                                               email: String(txtNewPassword.text!))
        
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
