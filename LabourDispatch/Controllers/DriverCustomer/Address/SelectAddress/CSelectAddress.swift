//
//  CSelectAddress.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

import Alamofire
import BottomPopup

class CSelectAddress: UIViewController {

    let cellReuseIdentifier = "cSelectAddressTableCell"
    
    // get buy now data in mutable array
    var arrBuyNowDataInMutableArray:NSMutableArray! = []
    
    // from menu bar
    var fromMenuBar:String!
    
    var finalPriceForPaymentInAddress:String!
    
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    
    // bottom view popup
    var height: CGFloat = 600 // height
    var topCornerRadius: CGFloat = 35 // corner
    var presentDuration: Double = 0.8 // present view time
    var dismissDuration: Double = 0.5 // dismiss view time
    let kHeightMaxValue: CGFloat = 600 // maximum height
    let kTopCornerRadiusMaxValue: CGFloat = 35 //
    let kPresentDurationMaxValue = 3.0
    let kDismissDurationMaxValue = 3.0
    
    var addressArrayMutable:NSMutableArray = []
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "Address"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.tableFooterView = UIView()
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    @IBOutlet weak var btnAddNewAddress:UIButton! {
        didSet {
            btnAddNewAddress.backgroundColor = .systemGreen
            btnAddNewAddress.layer.cornerRadius = 26
            btnAddNewAddress.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // print(finalPriceForPaymentInAddress as Any)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnAddNewAddress.addTarget(self, action: #selector(addPayment), for: .touchUpInside)
        
        self.tbleView.separatorColor = .clear

        self.gradientNavigation()
        
        
        
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keyBackOrSlide") {
            if myLoadedString == "backOrMenu" {
                       
                // menu
                btnBack.setImage(UIImage(named: "menu"), for: .normal)
                self.sideBarMenuClick()
            } else {
                       
                       // back
                btnBack.setImage(UIImage(systemName: "arrow.left"), for: .normal)
                btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
            }
                   
        } else {
                   
                   // back
            btnBack.setImage(UIImage(named: "menu"), for: .normal)
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.savedAddressList()
    }
    
    @objc func sideBarMenuClick() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyBackOrSlide")
        defaults.setValue(nil, forKey: "keyBackOrSlide")
        
        if revealViewController() != nil {
        btnBack.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
          }
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- GRADIENT ANIMATOR -
    @objc func gradientNavigation() {
        let gradientView = GradientAnimator(frame: navigationBar.frame, theme: .NeonLife, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
        navigationBar.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
    }
    
    // MARK:- PUSH TO PAYMENT SCREEN -
    @objc func addPayment() {
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CAddNewAddressId") as? CAddNewAddress
        push!.editOrAdd = "addAddress"
        self.navigationController?.pushViewController(push!, animated: true)
    }

    
    
    // MARK:- WEBSERVICE ( CATEGORIES ) -
    @objc func savedAddressList() {
        
        self.arrListOfAllMyOrders.removeAllObjects()
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "fetching all address...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
         // let str:String = person["role"] as! String
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = AddressList(action: "addresslist",
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
                        
                        /*
                         City = Dwarka;
                         Zipcode = 110075;
                         address = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
                         addressId = 17;
                         addressLine2 = "";
                         company = "";
                         country = "";
                         deliveryType = Evs;
                         firstName = Dishant;
                         lastName = Rajput;
                         mobile = 8287632340;
                         state = Delhi;
                         */
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                            
                            self.tbleView.delegate = self
                            self.tbleView.dataSource = self
                            self.tbleView.reloadData()
                            
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
    
    /*
     [action] => addpurchese
     [userId] => 36
     [productDetails] => [{"productId":"3","price":"60.0","Quantity":"1"}]
     [totalAmount] => 216.0
     [ShippingName] => deepak
     [ShippingAddress] => Vvip homesG noida
     [ShippingCity] => G noida
     [ShippingState] => Uttar pradesh
     [ShippingZipcode] => 201309
     [ShippingPhone] => 7906703537
     [transactionId] => 1000141000
     */
}


extension CSelectAddress: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell:CSelectAddressTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CSelectAddressTableCell
        
        cell.backgroundColor = .white
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
      
        cell.accessoryType = .disclosureIndicator
        
        /*
         City = Meerut;
         Zipcode = 250002;
         address = "ChandrrlokSabun Gotham ";
         addressId = 3;
         deliveryType = Home;
         firstName = deepu;
         lastName = singhal;
         mobile = 8533959518;
         state = "Uttar Pradesh ";
         */
        
        let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        cell.lblUserName.text = (item!["firstName"] as! String)+" "+(item!["lastName"] as! String)
        cell.lblFullAddress.text = (item!["address"] as! String)+(item!["addressLine2"] as! String)+", "+(item!["City"] as! String)+", "+(item!["state"] as! String)+"\nPincode :"+(item!["Zipcode"] as! String)+"\n\n"+(item!["mobile"] as! String)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // tableView .deselectRow(at: indexPath, animated: true)
        
        // tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
         
        
        if let myLoadedString = UserDefaults.standard.string(forKey: "keyForOnlyAddress") {
            if myLoadedString == "onlyAddressFromMenu" {
            
            
            // for edit or add address
            let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
                
                let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CAddNewAddressId") as? CAddNewAddress
                settingsVCId!.editOrAdd = "editAddress"
                settingsVCId!.dictGetSavedAddressForEdit = item as NSDictionary?
                self.navigationController?.pushViewController(settingsVCId!, animated: true)
                
            } else {
            
                let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
                
                
                
                
                
                
                guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
                popupVC.height = self.height
                popupVC.topCornerRadius = self.topCornerRadius
                popupVC.presentDuration = self.presentDuration
                popupVC.dismissDuration = self.dismissDuration
                //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
                popupVC.popupDelegate = self
                popupVC.strGetDetails = "confirmAndPayNow"
                popupVC.dictGetOrdersDetails = item as NSDictionary?
                
                // popupVC.getAddress = (item!["address"] as! String)+", "+(item!["City"] as! String)+", "+(item!["state"] as! String)+"\nPincode :"+(item!["Zipcode"] as! String)
                
                self.addressArrayMutable.removeAllObjects()
                
                let myDictionary: [String:String] = [
                    
                    "productImage":String(""),
                    "productName":(item!["firstName"] as! String)+" "+(item!["lastName"] as! String),
                    "productPrice":String(""),
                    "productQuantity":String(""),
                    "productState":(item!["state"] as! String),
                    "productCity":(item!["City"] as! String),
                    "productZipcode":(item!["Zipcode"] as! String),
                    "productAddress":(item!["address"] as! String),
                    "productPhoneNumber":(item!["mobile"] as! String)
                    
                ]
                
                var res = [[String: String]]()
                res.append(myDictionary)
                
                self.addressArrayMutable.addObjects(from: res)
                
                popupVC.arrayMuGetAddress = self.addressArrayMutable
                popupVC.arrayGetBuyNowData = self.arrBuyNowDataInMutableArray
                
                // print(addressArrayMutable as Any)
                
                popupVC.finalPriceForPaymentInExamplePopup = finalPriceForPaymentInAddress
                self.present(popupVC, animated: true, completion: nil)
                
            }
            
            
        } else {
            
            let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
            
            
            
            
            
            
            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "secondVC") as? ExamplePopupViewController else { return }
            popupVC.height = self.height
            popupVC.topCornerRadius = self.topCornerRadius
            popupVC.presentDuration = self.presentDuration
            popupVC.dismissDuration = self.dismissDuration
            //popupVC.shouldDismissInteractivelty = dismissInteractivelySwitch.isOn
            popupVC.popupDelegate = self
            popupVC.strGetDetails = "confirmAndPayNow"
            popupVC.dictGetOrdersDetails = item as NSDictionary?
            
            // popupVC.getAddress = (item!["address"] as! String)+", "+(item!["City"] as! String)+", "+(item!["state"] as! String)+"\nPincode :"+(item!["Zipcode"] as! String)
            
            self.addressArrayMutable.removeAllObjects()
            
            let myDictionary: [String:String] = [
                
                "productImage":String(""),
                "productName":(item!["firstName"] as! String)+" "+(item!["lastName"] as! String),
                "productPrice":String(""),
                "productQuantity":String(""),
                "productState":(item!["state"] as! String),
                "productCity":(item!["City"] as! String),
                "productZipcode":(item!["Zipcode"] as! String),
                "productAddress":(item!["address"] as! String),
                "productPhoneNumber":(item!["mobile"] as! String)
                
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addressArrayMutable.addObjects(from: res)
            
            popupVC.arrayMuGetAddress = self.addressArrayMutable
            popupVC.arrayGetBuyNowData = self.arrBuyNowDataInMutableArray
            
            // print(addressArrayMutable as Any)
            
            popupVC.finalPriceForPaymentInExamplePopup = finalPriceForPaymentInAddress
            self.present(popupVC, animated: true, completion: nil)
            
        }
        
        
        
        
        
        
    }
    
    // func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // tableView.cellForRow(at: indexPath)?.accessoryType = .none
    // }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return UITableView.automaticDimension
    }
    
}

extension CSelectAddress: UITableViewDelegate {
    
}

extension CSelectAddress: BottomPopupDelegate {
    
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
        // one
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
             //  defaults.set("ConfirmDismissSuccess", forKey: "keyConfirmAndPayClickByUser")
        
        let defaults = UserDefaults.standard
        if let myString = defaults.string(forKey: "keyConfirmAndPayClickByUser") {
            // print("ConfirmDismissSuccess \(myString)")
            
            // keyTotalpriceIs
            if "\(myString)" == "ConfirmDismissSuccess" {
                
                
                if let myString2 = defaults.string(forKey: "keyTotalpriceIs") {
                    
                    print(myString2 as Any) // total price to pay
                    
                    
                    
                    if let loadedTasks = UserDefaults.standard.array(forKey: "keySaveAddressAndOrderDetails") as? [[String: Any]] {
                        // print(loadedTasks)
                    
                    
                        let defaults = UserDefaults.standard
                        defaults.set("", forKey: "keyTotalpriceIs")
                        defaults.set(nil, forKey: "keyTotalpriceIs")
                    
                        defaults.set("", forKey: "keyConfirmAndPayClickByUser")
                        defaults.set(nil, forKey: "keyConfirmAndPayClickByUser")
                        
                        defaults.set("", forKey: "keySaveAddressAndOrderDetails")
                        defaults.set(nil, forKey: "keySaveAddressAndOrderDetails")
                    
                    // push to payment
                        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CSelectPaymetScreenId") as? CSelectPaymetScreen
                        push!.fullArrayProductDetails = loadedTasks as NSArray
                        push!.strTotalAmountToPay = myString2
                        self.navigationController?.pushViewController(push!, animated: true)
                    }
                }
                
                
                
                
            }
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
       
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}
