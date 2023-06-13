//
//  CDashboard.swift
//  Alien Broccoli
//
//  Created by Apple on 30/09/20.
//

import UIKit

class CDashboard: UIViewController {

    var dictOfNotificationPopup:NSDictionary!
    
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_COLOR
        }
    }
    
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "DASHBOARD"
            lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.tintColor = .black
        }
    }
    @IBOutlet weak var btnEdit:UIButton!
    
    @IBOutlet weak var btnStopSchedule:UIButton! {
        didSet {
            btnStopSchedule.layer.cornerRadius = 4
            btnStopSchedule.clipsToBounds = true
            btnStopSchedule.backgroundColor = UIColor.init(red: 240.0/255.0, green: 210.0/255.0, blue: 70.0/255.0, alpha: 1) // 240, 210, 70
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    
     @IBOutlet weak var btnGroup:UIButton!
    
    @IBOutlet weak var btnNewRequest:UIButton! {
        didSet {
            btnNewRequest.setTitle("Orders", for: .normal)
            btnNewRequest.backgroundColor = APP_BASIC_COLOR
            btnNewRequest.layer.cornerRadius = 6
            btnNewRequest.clipsToBounds = true
            btnNewRequest.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var btnDeliveredHistory:UIButton! {
        didSet {
            btnDeliveredHistory.setTitle("Shop Now", for: .normal)
            btnDeliveredHistory.backgroundColor = APP_BASIC_COLOR
            btnDeliveredHistory.layer.cornerRadius = 6
            btnDeliveredHistory.clipsToBounds = true
            btnDeliveredHistory.setTitleColor(.black, for: .normal)
        }
    }
    
    @IBOutlet weak var imgVieww:UIImageView!
    
    @IBOutlet weak var switchh:UISwitch! {
        didSet {
            switchh.isHidden = true
        }
    }
    
    @IBOutlet weak var bottomVieww:UIView! {
        didSet {
            bottomVieww.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // self.btnGroup.addTarget(self, action: #selector(jobHistoryClickMethod), for: .touchUpInside)
        self.btnEdit.addTarget(self, action: #selector(editClickMethod), for: .touchUpInside)
        
        self.btnDeliveredHistory.addTarget(self, action: #selector(shopNowClickMethod), for: .touchUpInside)
        self.btnNewRequest.addTarget(self, action: #selector(orderClickMethod), for: .touchUpInside)
        
        /*
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyLoginFullData")
        defaults.setValue(nil, forKey: "keyLoginFullData")
        */
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
              print(person as Any)
            
            /*
             ["ssnImage": , "logitude": , "gender": , "fullName": deepak gupta, "AccountNo": , "wallet": 0, "state": , "userId": 36, "TotalCartItem": 0, "role": User, "AutoInsurance": , "country": , "device": iOS, "middleName": , "lastName": , "firebaseId": , "socialType": , "drivlingImage": , "contactNumber": 7906703537, "RoutingNo": , "latitude": , "socialId": , "deviceToken": 111111111111111111111, "zipCode": , "BankName": , "accountType": , "address": VVIP Homes, Gaur City 2, Chipyana Khurd Urf Tigri, Uttar Pradesh 201009, India, "email": developer14deepakgupta@gmail.com, "image": http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/users/1599742571IMG-20200811-WA0007.jpg, "longitude": , "dob": , "AccountHolderName": ]
             (lldb)
             */
            
            self.lblTitle.text      = "Welcome, "+(person["fullName"] as! String)
            
            self.imgVieww.sd_setImage(with: URL(string: (person["image"] as! String)), placeholderImage: UIImage(named: "logo"))
            
        } else {
            // self.plusDriverLogin()
        }
        
        self.switchh.addTarget(self, action: #selector(switchhClickMethod), for: .valueChanged)
        // self.btnStopSchedule.addTarget(self, action: #selector(pushToDashboardPD), for: .touchUpInside)
        
        
        
        // print(dictOfNotificationPopup as Any)
        
        self.sideBarMenuClick()
        
    }
    
    @objc func orderClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderHistoryId") as? COrderHistory
        self.navigationController?.pushViewController(push!, animated: true)
        
        
        
        
        /*
        guard let popupViewController = segue.destination as? PopupViewController else { return }
        
        switch blurStyleSegmentControl.selectedSegmentIndex {
        case 0:
            popupViewController.customBlurEffectStyle = nil
        case 1:
            popupViewController.customBlurEffectStyle = .light
        case 2:
            popupViewController.customBlurEffectStyle = .extraLight
        case 3:
            popupViewController.customBlurEffectStyle = .dark
        default:
            break
        }
        */
        
        
        
        
        
        
        
        
    }
    
    // MARK:- JOB HISTORY -
    @objc func shopNowClickMethod() {

          let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CShopNowId") as? CShopNow
          self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    // MARK:- EDIT -
    @objc func editClickMethod() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CEditProfileId") as? CEditProfile
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
    @objc func switchhClickMethod() {
        
        if switchh.isOn {
            print("on")
            // self.availaibilityOnOrOff(strOnOff: "1")
        } else {
            print("off")
            // self.availaibilityOnOrOff(strOnOff: "0")
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
    
    // MARK:- PUSH TO SPOT SCHEDULING -
    @objc func pushToDashboardPD() {
         // let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PDSpotSchedulingId") as? PDSpotScheduling
         // self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    /*
    // MARK:- WEBSERVICE ( PLUS DRIVER LOGIN ) -
    @objc func availaibilityOnOrOff(strOnOff:String) {
           
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
       
        let urlString = BASE_URL_EXPRESS_PLUS
                  
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! RegistrationTableCell
        
        /*
         [action] => onoff
         [userId] => 123
         [availableStatus] => 0
         */
        
        var parameters:Dictionary<AnyHashable, Any>!
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            
            let x2 : Int = person["userId"] as! Int
            let driverId = String(x2)
            
            if strOnOff == "0" {
                parameters = [
                          "action"              : "onoff",
                          "userId"              : String(driverId),
                          "availableStatus"     : String("0")
                ]
            } else {
                parameters = [
                          "action"              : "onoff",
                          "userId"              : String(driverId),
                          "availableStatus"     : String("1")
                ]
            }
        }
        print("parameters-------\(String(describing: parameters))")
                      
        Alamofire.request(urlString, method: .post, parameters: parameters as? Parameters).responseJSON {
                        response in
                  
            switch(response.result) {
                              case .success(_):
                                if let data = response.result.value {

                                    let JSON = data as! NSDictionary
                                   print(JSON as Any)
                                  
                                  var strSuccess : String!
                                  strSuccess = JSON["status"]as Any as? String
                                  
                                    // var strSuccessAlert : String!
                                    // strSuccessAlert = JSON["msg"]as Any as? String
                                  
                                  if strSuccess == String("success") {
                                   print("yes")
                                    
                                     ERProgressHud.sharedInstance.hide()
                                    
                                    var strSuccess2 : String!
                                    strSuccess2 = JSON["msg"]as Any as? String
                                    
                                    let alert = UIAlertController(title: String(strSuccess), message: String(strSuccess2), preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                                        // self.dismiss(animated: true, completion: nil)
                                        
                                        
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                  }
                                  else {
                                   print("no")
                                    ERProgressHud.sharedInstance.hide()
                                   
                                  }
                              }

                              case .failure(_):
                                  print("Error message:\(String(describing: response.result.error))")
                                  
                                  ERProgressHud.sharedInstance.hide()
                                  
                                  let alertController = UIAlertController(title: nil, message: "Server Issue", preferredStyle: .actionSheet)
                                  
                                  let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                          UIAlertAction in
                                          NSLog("OK Pressed")
                                      }
                                  
                                  alertController.addAction(okAction)
                                  
                                  self.present(alertController, animated: true, completion: nil)
                                  
                                  break
                        }
        }
    }
    */
    
}
