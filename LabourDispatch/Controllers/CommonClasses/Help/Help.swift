//
//  Help.swift
//  ExpressPlus
//
//  Created by Apple on 06/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import MessageUI

import Alamofire

class Help: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imglogo:UIImageView! {
        didSet {
            imglogo.layer.cornerRadius = 0
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
            lblNavigationTitle.text = "HELP"
            lblNavigationTitle.tintColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = NAVIGATION_BACK_COLOR
        }
    }
    
    @IBOutlet weak var btnPhone:UIButton! {
        didSet {
            btnPhone.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    @IBOutlet weak var btnEmil:UIButton! {
        didSet {
            btnEmil.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnEmailTitle:UIButton! {
        didSet {
            btnEmailTitle.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    @IBOutlet weak var btnTermsAndConditions:UIButton! {
        didSet {
            btnTermsAndConditions.setTitleColor(APP_BASIC_COLOR, for: .normal)
        }
    }
    
    var strPhone:String!
    
    @IBOutlet weak var lblCopyrightText:UILabel! {
        didSet {
            lblCopyrightText.textColor = APP_BASIC_COLOR
            lblCopyrightText.text = "© 2020 The Global Hair. All Right Reserved."
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // self.view.backgroundColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        self.view.backgroundColor = .black
        
        self.btnTermsAndConditions.addTarget(self, action: #selector(openTermsAndPrivacyPopup), for: .touchUpInside)
        
        self.sideBarMenuClick()
        
        self.helpWB()
    }
    
    @objc func sideBarMenuClick() {
        self.view.endEditing(true)
        if revealViewController() != nil {
            btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }

    
    @objc func openTermsAndPrivacyPopup() {
        let alertController = UIAlertController(title: nil, message: "Help", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Terms", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            
            if let url = URL(string: THE_GLOBAL_HAIR_TERMS) {
                UIApplication.shared.open(url)
            }
            
        }
        let okAction3 = UIAlertAction(title: "Privacy  Policy", style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
            
            if let url = URL(string: THE_GLOBAL_HAIR_PRIVACY) {
                UIApplication.shared.open(url)
            }
            
        }
        let okAction2 = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("OK Pressed")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(okAction3)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func helpWB() {
        // self.arrListOfAllMyOrders.removeAllObjects()
        
        self.view.endEditing(true)
        
        let params = HelpWB(action: "help")
        
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
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                            
                            var dict: Dictionary<AnyHashable, Any>
                             dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            // (dict["phone"] as! String)
                            self.btnPhone.setTitle((dict["phone"] as! String), for: .normal)
                            self.btnEmil.setTitle((dict["eamil"] as! String), for: .normal)
                            
                            self.strPhone = (dict["phone"] as! String)
                            
                            self.btnPhone.addTarget(self, action: #selector(self.callMethodClick), for: .touchUpInside)
                            self.btnEmil.addTarget(self, action: #selector(self.mailMethodClick), for: .touchUpInside)
                            
                            
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
        // }
    
    }
    
    
    @objc func callMethodClick() {
        if let url = URL(string: "tel://\(self.strPhone ?? "")"),
        UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func mailMethodClick() {
           let mailComposeViewController = configuredMailComposeViewController()
           if MFMailComposeViewController.canSendMail() {
               self.present(mailComposeViewController, animated: true, completion: nil)
           } else {
               self.showSendMailErrorAlert()
           }
       }
    
       func configuredMailComposeViewController() -> MFMailComposeViewController {
           let mailComposerVC = MFMailComposeViewController()
           mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
    
            mailComposerVC.setToRecipients([self.strPhone])
            mailComposerVC.setSubject("I AM SUBJECT")
            mailComposerVC.setMessageBody("I AM MESSAGE BODY", isHTML: false)
    
            return mailComposerVC
        }
    
        func showSendMailErrorAlert() {
            let alert = UIAlertController(title: "Could Not Send Email", message: "You can always access your content by signing back in",         preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Ok",
                                          style: UIAlertAction.Style.default,
                                          handler: {(_: UIAlertAction!) in
                                            //Sign out action
            }))
            self.present(alert, animated: true, completion: nil)

        }
    
        // MARK: MFMailComposeViewControllerDelegate Method
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true, completion: nil)
        }
    
}
