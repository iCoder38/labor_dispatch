//
//  MenuControllerVC.swift
//  SidebarMenu
//
//  Created by Apple  on 16/10/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import Alamofire

import SDWebImage

class MenuControllerVC: UIViewController {

    let cellReuseIdentifier = "menuControllerVCTableCell"
    
    var bgImage: UIImageView?
    
    var roleIs:String!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = .black // NAVIGATION_BACKGROUND_COLOR
        }
    }
    
    @IBOutlet weak var viewUnderNavigation:UIView! {
        didSet {
            // viewUnderNavigation.backgroundColor = .black
            viewUnderNavigation.backgroundColor = UIColor.init(red: 237.0/255.0, green: 186.0/255.0, blue: 204.0/255.0, alpha: 1)
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MENU"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var imgSidebarMenuImage:UIImageView! {
        didSet {
            imgSidebarMenuImage.backgroundColor = .clear
            imgSidebarMenuImage.layer.cornerRadius = 30
            imgSidebarMenuImage.clipsToBounds = true
        }
    }
    
    
    
    // user
    var arrSidebarMenuTitle = ["Dashboard", "Edit Profile","Shop Now", "Order History", "Blog", "Address", "Hairloss Support Group", "Medical Billing", "Wing Customization", "Wing Dry Cleaning", "Wing Alteration", "Change Password", "Help", "Logout"]
    var arrSidebarMenuImage = ["home", "edit","cart", "how", "reminder","reminder", "hairloss", "medical", "wig", "dry", "alteration", "lcok", "help", "logout"]
    
    
    
    
    
    
    // seller
    var arrSidebarMenuDriverTitle = ["Dashboard","Edit Profile", "Manage Product", "Membership", "Blog", "Hairloss Support Group", "Medical Billing", "Change Password", "Help", "Logout"]
    var arrSidebarMenuDriverImage = ["home", "edit", "hairloss", "dollar_white", "how", "hairloss", "home", "lcok", "help", "logout"]
    
    
    
    
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "JOHN SMITH"
            lblUserName.textColor = .white
        }
    }
    @IBOutlet weak var lblPhoneNumber:UILabel! {
        didSet {
            lblPhoneNumber.textColor = .white
        }
    }
    
    @IBOutlet var menuButton:UIButton!
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            tbleView.delegate = self
            tbleView.dataSource = self
            tbleView.tableFooterView = UIView.init()
            tbleView.backgroundColor = NAVIGATION_COLOR
            // tbleView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50)
            tbleView.separatorColor = .white
        }
    }
    
    @IBOutlet weak var lblMainTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideBarMenuClick()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tbleView.separatorColor = .white // UIColor.init(red: 60.0/255.0, green: 110.0/255.0, blue: 160.0/255.0, alpha: 1)
        
        self.view.backgroundColor = .white // NAVIGATION_BACKGROUND_COLOR
        
        self.sideBarMenuClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
             if person["role"] as! String == "Seller" {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
             } else {
                
                self.lblUserName.text = (person["fullName"] as! String)
                self.lblPhoneNumber.text = (person["contactNumber"] as! String)
                
                self.imgSidebarMenuImage.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
                self.imgSidebarMenuImage.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            }
             
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    @objc func sideBarMenuClick() {
        
        if revealViewController() != nil {
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
}

extension MenuControllerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            if person["role"] as! String == "Seller" {
                return arrSidebarMenuDriverTitle.count
            } else {
                return arrSidebarMenuTitle.count
            }
            
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuControllerVCTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MenuControllerVCTableCell
        
        cell.backgroundColor = .clear
      
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            if person["role"] as! String == "Seller" {
            
                cell.lblName.text = arrSidebarMenuDriverTitle[indexPath.row]
                cell.lblName.textColor = .black
                cell.imgProfile.backgroundColor = .orange
                cell.imgProfile.image = UIImage(named: arrSidebarMenuDriverImage[indexPath.row])
                cell.imgProfile.backgroundColor = .clear
                
            } else {
                
                cell.lblName.text = arrSidebarMenuTitle[indexPath.row]
                cell.lblName.textColor = .black
                cell.imgProfile.backgroundColor = .orange
                cell.imgProfile.image = UIImage(named: arrSidebarMenuImage[indexPath.row])
                
                let icon = UIImageView(image: cell.imgProfile.image!.withRenderingMode(.alwaysTemplate))
                icon.tintColor = .red
                
                cell.imgProfile.backgroundColor = .clear
                
            }
            
        }
        
        
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            if person["role"] as! String == "Seller" {
        
                if arrSidebarMenuDriverTitle[indexPath.row] == "Dashboard" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "TGHNDashboardId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Manage Product" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "TGMyProductsId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Delivery Request" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DDeliveryRequestId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Delivered History" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "DDeliveredHistoryId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Help" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Logout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                    }))
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                     }))
                    self.present(alert, animated: true, completion: nil)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Blog" {
                    
                    if let url = URL(string: URL_HARILOSS_SUPPORT_GROUP) {
                        UIApplication.shared.open(url)
                    }
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Hairloss Support Group" {
                    
                    if let url = URL(string: URL_HARILOSS_SUPPORT_GROUP) {
                        UIApplication.shared.open(url)
                    }
                    
                } else if arrSidebarMenuDriverTitle[indexPath.row] == "Medical Billing" {
                    
                    if let url = URL(string: URL_HARILOSS_SUPPORT_GROUP) {
                        UIApplication.shared.open(url)
                    }
                    
                }
                
            } else {
                
                if arrSidebarMenuTitle[indexPath.row] == "Dashboard" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CDashboardId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Shop Now" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CShopNowId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuTitle[indexPath.row] == "Order History" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "COrderHistoryId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuTitle[indexPath.row] == "Help" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "HelpId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                        
                } else if arrSidebarMenuTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Address" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
                    
                    let myString2 = "onlyAddressFromMenu"
                    UserDefaults.standard.set(myString2, forKey: "keyForOnlyAddress")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CSelectAddressId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Edit Profile" {
                    
                    let myString = "backOrMenu"
                    UserDefaults.standard.set(myString, forKey: "keyBackOrSlide")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CEditProfileId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Change Password" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Location" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CLocationsId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Documents" {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                    self.view.window?.rootViewController = sw
                    let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "CDocumentsId")
                    let navigationController = UINavigationController(rootViewController: destinationController!)
                    sw.setFront(navigationController, animated: true)
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Hairloss Support Group" {
                    
                    if let url = URL(string: URL_HARILOSS_SUPPORT_GROUP) {
                        UIApplication.shared.open(url)
                    }
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Medical Billing" {
                    
                    if let url = URL(string: URL_MEDICAL_BILLING) {
                        UIApplication.shared.open(url)
                    }
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Wing Customization" {
                    
                    if let url = URL(string: URL_WING_CUSTOMIZATION) {
                        UIApplication.shared.open(url)
                    }
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Wing Dry Cleaning" {
                    
                    if let url = URL(string: URL_WING_DRY_CLEANING) {
                        UIApplication.shared.open(url)
                    }
                    
                } else if arrSidebarMenuTitle[indexPath.row] == "Wing Alteration" {
                    
                    if let url = URL(string: URL_WING_ALTERNATION) {
                        UIApplication.shared.open(url)
                    }
                     
                } else if arrSidebarMenuTitle[indexPath.row] == "Logout" {
                    
                    let alert = UIAlertController(title: String("Logout"), message: String("Are you sure you want to logout ?"), preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Yes, Logout", style: .default, handler: { action in
                        self.logoutWB()
                    }))
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                     }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
                
                
            }
        
        }
        
    }
    
    
    @objc func logoutWB() {
         ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = LogoutFromApp(action: "logout",
                                   userId: String(myString))
        
        AF.request(BASE_URL_THE_GLOBAL_HAIR,
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
                           
                            let defaults = UserDefaults.standard
                            defaults.setValue("", forKey: "keyLoginFullData")
                            defaults.setValue(nil, forKey: "keyLoginFullData")

                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let sw = storyboard.instantiateViewController(withIdentifier: "sw") as! SWRevealViewController
                            self.view.window?.rootViewController = sw
                            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedId")
                            let navigationController = UINavigationController(rootViewController: destinationController!)
                            sw.setFront(navigationController, animated: true)
                            
                            
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MenuControllerVC: UITableViewDelegate {
    
}
