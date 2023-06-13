//
//  GetStarted.swift
//  TheGlobalHair
//
//  Created by Apple on 18/11/20.
//

import UIKit

class GetStarted: UIViewController {

    @IBOutlet weak var btnCustomer:UIButton! {
        didSet {
            btnCustomer.layer.cornerRadius = 4
            btnCustomer.clipsToBounds = true
            btnCustomer.backgroundColor = APP_BASIC_COLOR
            btnCustomer.setTitle("Customer", for: .normal)
            btnCustomer.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnTGHNpartner:UIButton! {
        didSet {
            btnTGHNpartner.layer.cornerRadius = 6
            btnTGHNpartner.clipsToBounds = true
            btnTGHNpartner.backgroundColor = APP_BASIC_COLOR
            btnTGHNpartner.setTitle("TGHN Partner", for: .normal)
            btnTGHNpartner.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var lblMessage:UILabel! {
        didSet {
            lblMessage.textColor = APP_BASIC_COLOR
            lblMessage.text = "Welcome to The Global Hair network"
        }
    }
    
    @IBOutlet weak var lblMessage2:UILabel! {
        didSet {
            lblMessage2.textColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.view.backgroundColor = UIColor.init(red: 24.0/255.0, green: 30.0/255.0, blue: 40.0/255.0, alpha: 1)
        
        self.btnCustomer.addTarget(self, action: #selector(enterViaCustomer), for: .touchUpInside)
        
        self.btnTGHNpartner.addTarget(self, action: #selector(enterViaTghnPartner), for: .touchUpInside)
        
        self.rememberMe()
    }
    
    @objc func rememberMe() {
        // MARK:- PUSH -
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            print(person as Any)
            
             let x : Int = person["subscriptionId"] as! Int
             let myString = String(x)
            
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
    }
    
    @objc func enterViaCustomer() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginId") as? Login
        push!.strLoginVia = "Member"
        self.navigationController?.pushViewController(push!, animated: true)
    }

    @objc func enterViaTghnPartner() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginId") as? Login
        push!.strLoginVia = "Seller"
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    
}
