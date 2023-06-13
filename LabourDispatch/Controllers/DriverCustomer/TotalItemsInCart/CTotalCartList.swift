//
//  CTotalCartList.swift
//  Alien Broccoli
//
//  Created by Apple on 05/10/20.
//

import UIKit

import Alamofire

class CTotalCartList: UIViewController {
    
    let cellReuseIdentifier = "cTotalCartListTableCell"
    
    var arrAddAllValues:NSMutableArray! = []
    
    // save add to cart food
    var addInitialMutable:NSMutableArray = []
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    @IBOutlet weak var lblShippingPriceIs:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
    
    @IBOutlet weak var lblFinalTotalPrice:UILabel!
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "MY CART"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.backgroundColor = .systemGreen
            btnCheckOut.setTitleColor(.white, for: .normal)
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
        
        self.btnCheckOut.addTarget(self, action: #selector(checkOutClickMethid), for: .touchUpInside)
        
        self.gradientNavigation()
        
        self.totalItemsInCart()
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

    
    // MARK:- WEBSERVICE ( TOTAL ITEMS IN CART ) -
        @objc func totalItemsInCart() {
            self.arrListOfAllMyOrders.removeAllObjects()
            self.arrAddAllValues.removeAllObjects()
            
            ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            self.view.endEditing(true)
            
             if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             let x : Int = (person["userId"] as! Int)
             let myString = String(x)
                
            let params = CartList(action: "getcarts",
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
                                
                               
                                let x : Int = JSON["TotalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" {
                                    self.lblNavigationTitle.isHidden = true
                                } else if myString == "" {
                                    self.lblNavigationTitle.isHidden = true
                                } else {
                                    self.lblNavigationTitle.isHidden = false
                                    self.lblNavigationTitle.text = "My Cart ("+String(myString)+")"
                                }
                                 
                                var ar : NSArray!
                                ar = (JSON["data"] as! Array<Any>) as NSArray
                                self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                                
                                // calculation part goes here
                                /*
                                 productId = 17;
                                 productImage = "";
                                 productName = "CBD Chia Parfait";
                                 productPrice = 28;
                                 productSKU = 4543;
                                 quantity = 6;
                                 userId = 71;
                                */
                               
                                // let numbers = [1, 12, 2, 9, 27]
                                // let total = numbers.reduce(0, +)
                                // print(total as Any)
                                
                                for addPriceWithQuantity in 0..<self.arrListOfAllMyOrders.count {
                                    
                                    let item = self.arrListOfAllMyOrders[addPriceWithQuantity] as? [String:Any]
                                    // print(item as Any)
                                    
                                    //  1. convert int into string
                                    
                                    // price
                                    let x : Int = (item!["productPrice"] as! Int)
                                    let myString = String(x)
                                    
                                    // quantity
                                    let x2 : Int = (item!["quantity"] as! Int)
                                    let myString2 = String(x2)
                                    
                                    let a = (myString as NSString).floatValue
                                    let b = (myString2 as NSString).floatValue
                                    
                                    let c = +(a*b)
                                    
                                    self.arrAddAllValues.add(c)
                                    
                                }
                                
                                let objCMutableArray = NSMutableArray(array: self.arrAddAllValues)
                                let swiftArray = objCMutableArray as NSArray as! [Float]
                                
                                let numbers = swiftArray // [1, 12, 2, 9, 27]
                                let total = numbers.reduce(0, +)
                                
                                // sub total
                                let x121 : Float = (total)
                                let myString121 = String(x121)
                                self.lblSubTotal.text = "$ "+String(myString121)
                                
                                
                                // SUB TOTAL + SHIPPING
                                
                                // convert shipping from string to float
                                let subTotal = total
                                let ShippingTotal = (self.lblShippingPriceIs.text! as NSString).floatValue
                                
                                let finalPriceAfterAllcarts = subTotal+ShippingTotal
                                
                                let x12 : Float = (finalPriceAfterAllcarts)
                                let myString12 = String(x12)
                                
                                
                                self.lblShippingPriceIs.text = "$ 0"
                                self.lblFinalTotalPrice.text = "$ "+String(myString12)
                                
                                ERProgressHud.sharedInstance.hide()
                                
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
    
    
    @objc func checkOutClickMethid() {
        self.addInitialMutable.removeAllObjects()
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyForOnlyAddress")
        defaults.setValue(nil, forKey: "keyForOnlyAddress")
        
        // push to address
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CSelectAddressId") as? CSelectAddress
        
        
        
        
        for pushPriceAndQuantity in 0..<self.arrListOfAllMyOrders.count {
        
            let item = self.arrListOfAllMyOrders[pushPriceAndQuantity] as? [String:Any]
            
            
            
            if item!["productImage"] as! String == "" {
                
                // id
                let x233 : Int = (item!["productId"] as! Int)
                let myString233 = String(x233)
                
                // price
                 let x : Int = (item!["productPrice"] as! Int)
                 let myString = String(x)
                
                // quantity
                let x2 : Int = (item!["quantity"] as! Int)
                let myString2 = String(x2)
                
                let myDictionary: [String:String] = [
                    
                    "productId":String(myString233),
                    "productImage":String(""),
                    "productName":(item!["productName"] as! String),
                    "productPrice":String(myString),
                    "productQuantity":String(myString2),
                    "productState":String(""),
                    "productCity":String(""),
                    "productZipcode":String(""),
                    "productAddress":String("")
                    
                ]
                
                var res = [[String: String]]()
                res.append(myDictionary)
                
                self.addInitialMutable.addObjects(from: res)
            } else {
                
                // id
                let x233 : Int = (item!["productId"] as! Int)
                let myString233 = String(x233)
                
                // price
                 let x : Int = (item!["productPrice"] as! Int)
                 let myString = String(x)
                
                // quantity
                let x2 : Int = (item!["quantity"] as! Int)
                let myString2 = String(x2)
                
                let myDictionary: [String:String] = [
                    
                    "productId":String(myString233),
                    "productImage":String(""),
                    "productName":(item!["productName"] as! String),
                    "productPrice":String(myString),
                    "productQuantity":String(myString2),
                    "productState":String(""),
                    "productCity":String(""),
                    "productZipcode":String(""),
                    "productAddress":String("")
                    
                ]
                
                var res = [[String: String]]()
                res.append(myDictionary)
                
                self.addInitialMutable.addObjects(from: res)
            }
            
        }
        
        push!.finalPriceForPaymentInAddress = self.lblFinalTotalPrice.text!
        push!.arrBuyNowDataInMutableArray = self.addInitialMutable
        self.navigationController?.pushViewController(push!, animated: true)
        
    }
    
}


extension CTotalCartList: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:CTotalCartListTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CTotalCartListTableCell
          
        let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        
        cell.lblProductDetails.text    = (item!["productName"] as! String)
         
        
        let x2 : Int = (item!["quantity"] as! Int)
        let myString2 = String(x2)
        
        let x22 : Int = (item!["productPrice"] as! Int)
        let myString22 = String(x22)
        
        cell.lblProductQuantityAndPrice.text = "Quantity : "+myString2+"\nPrice : $ "+myString22
        
        
        cell.imgProductImage.sd_setImage(with: URL(string: (item!["productImage"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        /*
         productId = 12;
         productImage = "";
         productName = "Green Roads Fruit and Hemp CBD Chews";
         productPrice = 80;
         productSKU = 76766;
         quantity = 1;
         userId = 71;
         */
        
        cell.btnDeleteItem.tag = indexPath.row
        cell.btnDeleteItem.addTarget(self, action: #selector(deleteCartFromItems), for: .touchUpInside)
        
        return cell
        
    }

    @objc func deleteCartFromItems(_ sender:UIButton) {
        
        let item = self.arrListOfAllMyOrders[sender.tag] as? [String:Any]
        // print(item as Any)
        
        let alert = UIAlertController(title: String("Delete Item"), message: String("Are you sure you want to delete.")+"' "+(item!["productName"] as! String)+" '"+" from your cart ?",
                                      
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes, Delete", style: .default, handler: { action in
             
            let x : Int = (item!["productId"] as! Int)
            let myString = String(x)
            
            self.deleteItemFromCart(strinproductId: myString)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
             
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- DELETE ITEM FROM CART -
    @objc func deleteItemFromCart(strinproductId:String) {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "deleting...")
            
        self.view.endEditing(true)
            
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            let x : Int = (person["userId"] as! Int)
            let myString = String(x)
                
            let params = DeleteCart(action: "deletecarts",
                                    userId: String(myString),
                                    productId: String(strinproductId))
            
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
                                // ERProgressHud.sharedInstance.hide()
                               
                                let x : Int = JSON["totalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" {
                                    self.lblNavigationTitle.isHidden = true
                                } else if myString == "" {
                                    self.lblNavigationTitle.isHidden = true
                                } else {
                                    self.lblNavigationTitle.isHidden = false
                                    self.lblNavigationTitle.text = "My Cart ("+String(myString)+")"
                                }
                                 
                                
                                self.totalItemsInCart()
                                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 100
    }
    
}

extension CTotalCartList: UITableViewDelegate {
    
}
