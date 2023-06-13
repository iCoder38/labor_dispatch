//
//  COrderHistory.swift
//  Alien Broccoli
//
//  Created by Apple on 06/10/20.
//

import UIKit
import Alamofire

class COrderHistory: UIViewController {

    let cellReuseIdentifier = "cOrderhistoryTableCell"
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "ORDERS HISTORY"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            
        }
    }
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            // self.tbleView.delegate = self
            // self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
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
        
        self.orderHistoryClickMethod()
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
    
    // MARK:- WEBSERVICE ( ORDER HISTORY DETAILS ) -
    @objc func orderHistoryClickMethod() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = OrderHistory(action: "purcheslist",
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
}

extension COrderHistory: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:COrderhistoryTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! COrderhistoryTableCell
          
        /*
         ShippingName = "Dishant Rajput";
         ShippingPhone = 8287632340;
         created = "2020-10-06 17:13:00";
         productDetails =             (
                             {
                 Quantity = 1;
                 price = 90;
                 productId = 13;
             },
                             {
                 Quantity = 5;
                 price = 30;
                 productId = 16;
             },
                             {
                 Quantity = 1;
                 price = 56;
                 productId = 14;
             },
                             {
                 Quantity = 2;
                 price = 34;
                 productId = 20;
             }
         );
         purcheseId = 47;
         shippingAddress = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
         shippingCity = Dwarka;
         shippingCountry = "";
         shippingState = Delhi;
         shippingZipcode = 110075;
         status = "";
         totalAmount = 364;
         transactionId = "";
         */
        
         let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        // print(item as Any)
        
        let x222 : Int = (item!["purcheseId"] as! Int)
        let myString222 = String(x222)
        
        cell.lblTitle.text    = "Item "+"#"+myString222//(item!["ShippingName"] as! String)
        cell.lblCreatedAt.text    = (item!["created"] as! String)
        
        // total number of products
        var ar : NSArray!
        ar = (item!["productDetails"] as! Array<Any>) as NSArray
        
        let x22 : Int = (item!["totalAmount"] as! Int)
        let myString22 = String(x22)
        
        cell.lblQuantity.text = "Products : "+String(ar.count)
        cell.lblPrice.text = "Price : $ "+myString22
        
        cell.accessoryType = .disclosureIndicator
        
         // cell.imgProfile.sd_setImage(with: URL(string: (item!["productImage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        let x : Int = (item!["purcheseId"] as! Int)
        let myString = String(x)
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderHistoryDetailsId") as? COrderHistoryDetails
        push!.productId = String(myString)
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 116
    }
    
}

extension COrderHistory: UITableViewDelegate {
    
}
