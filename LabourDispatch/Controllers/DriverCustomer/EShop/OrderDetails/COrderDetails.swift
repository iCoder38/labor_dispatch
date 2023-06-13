//
//  COrderDetails.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit
import Alamofire

class COrderDetails: UIViewController, UITextFieldDelegate {
    
    var dashboardTitle = ["CBD Oil","CBD Gummies","CBD Capsules","CBD Topicals","CBD Candy","CBD Edibles"]
    var dashboardImage = [""]
    
    var productDetailsId:Int!
    var strTitleIs:String!
    
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
            lblNavigationTitle.text = "CBD OIL"
        }
    }
    
    @IBOutlet weak var btnCart:UIButton! {
        didSet {
            btnCart.isHidden = true
            btnCart.tintColor = .black
        }
    }
    
    @IBOutlet weak var lblCartCount:UILabel! {
        didSet {
            self.lblCartCount.isHidden = true
        }
    }
    
    // MARK:- COLLECTION VIEW SETUP -
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
               //collection
            // clView!.dataSource = self
            // clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
        }
    }
    
    @IBOutlet weak var btnMenu:UIButton! {
        didSet {
            btnMenu.isHidden = false
            btnMenu.tintColor = .black
        }
    }
    
    @IBOutlet weak var btnSearch:UIButton!
    @IBOutlet weak var txtSearch:UITextField! {
        didSet {
            txtSearch.placeholder = "search..."
            txtSearch.backgroundColor = .white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.txtSearch.delegate = self
        
        self.btnMenu.addTarget(self, action: #selector(sideBarMenuClick), for: .touchUpInside)
        self.btnCart.addTarget(self, action: #selector(cartClickMwthod), for: .touchUpInside)
        
        self.lblNavigationTitle.text = strTitleIs
        
        self.gradientNavigation()
        
        self.btnSearch.addTarget(self, action: #selector(searchShopDetails), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.txtSearch.text = ""
        
        self.productDetailsWB()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // MARK:- GRADIENT ANIMATOR -
    @objc func gradientNavigation() {
        let gradientView = GradientAnimator(frame: navigationBar.frame, theme: .NeonLife, _startPoint: GradientPoints.bottomLeft, _endPoint: GradientPoints.topRight, _animationDuration: 3.0)
        navigationBar.insertSubview(gradientView, at: 0)
        gradientView.startAnimate()
    }
    
    @objc func cartClickMwthod() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CTotalCartListId") as? CTotalCartList
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
    }
    
    // MARK:- SIDE BAR MENU -
    @objc func sideBarMenuClick() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- WEBSERVICE ( PRODUCT DETAILS ) -
    @objc func productDetailsWB() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        self.arrListOfAllMyOrders.removeAllObjects()
        
        self.view.endEditing(true)
        
        let x : Int = (productDetailsId!)
        let myString = String(x)
        
        let params = ShopProductDetails(action: "productlist",
                                        categoryId: String(myString),
                                        keyword: "")
        print(params as Any)
        
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
                           
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                            
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
    
    // MARK:- WEBSERVICE ( TOTAL ITEMS IN CART ) -
        @objc func totalItemsInCart() {
            // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
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
                            print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                ERProgressHud.sharedInstance.hide()
                               
                                // var ar : NSArray!
                                // ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                                
                                // var strCartCount : String!
                                // strCartCount = JSON["TotalCartItem"]as Any as? String
                                // print(strCartCount as Any)
                                
                                let x : Int = JSON["TotalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" {
                                    self.lblCartCount.isHidden = true
                                    self.btnCart.isHidden = true
                                } else if myString == "" {
                                    self.lblCartCount.isHidden = true
                                    self.btnCart.isHidden = true
                                } else {
                                    self.lblCartCount.isHidden = false
                                    self.lblCartCount.text = String(myString)
                                    
                                    self.btnCart.isHidden = false
                                    self.btnCart.setImage(UIImage(systemName: "cart.fill"), for: .normal)
                                }
                               
                                self.clView.delegate = self
                                self.clView.dataSource = self
                                self.clView.reloadData()
                                
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
    
    // MARK:-  WEBSERVICE ( ADD TO CART ) -
    @objc func addToCart() {
            // ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
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
                            print(JSON as Any)
                            
                            var strSuccess : String!
                            strSuccess = JSON["status"]as Any as? String
                            
                            // var strSuccess2 : String!
                            // strSuccess2 = JSON["msg"]as Any as? String
                            
                            if strSuccess == String("success") {
                                print("yes")
                                ERProgressHud.sharedInstance.hide()
                               
                                // var ar : NSArray!
                                // ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                                
                                // var strCartCount : String!
                                // strCartCount = JSON["TotalCartItem"]as Any as? String
                                // print(strCartCount as Any)
                                
                                let x : Int = JSON["TotalCartItem"] as! Int
                                let myString = String(x)
                                
                                if myString == "0" {
                                    self.lblCartCount.isHidden = true
                                    self.btnCart.isHidden = true
                                } else if myString == "" {
                                    self.lblCartCount.isHidden = true
                                    self.btnCart.isHidden = true
                                } else {
                                    self.lblCartCount.isHidden = false
                                    self.lblCartCount.text = String(myString)
                                    
                                    self.btnCart.isHidden = false
                                    self.btnCart.setImage(UIImage(systemName: "cart.fill"), for: .normal)
                                }
                               
                                self.clView.delegate = self
                                self.clView.dataSource = self
                                self.clView.reloadData()
                                
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
    
    // MARK:- SEARCH -
    @objc func searchShopDetails() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "searching...")
        
        self.arrListOfAllMyOrders.removeAllObjects()
        
        self.view.endEditing(true)
        
        let x2 : Int = (productDetailsId!)
        let myString2 = String(x2)
        
        // if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        // let x : Int = (person["userId"] as! Int)
        // let myString = String(x)
            
        let params = CustomerSearch(action: "productlist",
                                    categoryId: String(myString2),
                                    keyword: String(txtSearch.text!))
        
        AF.request(BASE_URL_ALIEN_BROCCOLI,
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
                        
                        // var strSuccess2 : String!
                        // strSuccess2 = JSON["msg"]as Any as? String
                        
                        if strSuccess == String("success") {
                            print("yes")
                            ERProgressHud.sharedInstance.hide()
                           
                            // var ar : NSArray!
                            // ar = (JSON["data"] as! Array<Any>) as NSArray
                            // self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                            
                            // var strCartCount : String!
                            // strCartCount = JSON["TotalCartItem"]as Any as? String
                            // print(strCartCount as Any)
                            
                            /*
                            let x : Int = JSON["TotalCartItem"] as! Int
                            let myString = String(x)
                            
                            if myString == "0" {
                                self.lblCartCount.isHidden = true
                                self.btnCart.isHidden = true
                            } else if myString == "" {
                                self.lblCartCount.isHidden = true
                                self.btnCart.isHidden = true
                            } else {
                                self.lblCartCount.isHidden = false
                                self.lblCartCount.text = String(myString)
                                
                                self.btnCart.isHidden = false
                                self.btnCart.setImage(UIImage(systemName: "cart.fill"), for: .normal)
                            }
                           */
                            
                            var ar : NSArray!
                            ar = (JSON["data"] as! Array<Any>) as NSArray
                            self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                            
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            self.clView.reloadData()
                            
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
}

extension COrderDetails: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    //Write Delegate Code Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cOrderDetailsCollectionCell", for: indexPath as IndexPath) as! COrderDetailsCollectionCell
           
        /*
         SKU = 1;
                     description = "<p>Book Book Book Book Book Book Book Book Book</p>
         \n";
                     image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1598878678_1_1.jpg";
                     price = 156;
                     productId = 1;
                     productName = "Spectrum CBD";
                     quantity = 10;
         */
        
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 0
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.6
        
        cell.viewCellBG.layer.borderColor = UIColor.lightGray.cgColor
        cell.viewCellBG.layer.borderWidth = 0.6
        
        
        cell.viewCellBG.backgroundColor = .systemGreen // APP_BUTTON_COLOR
        
        let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        cell.lblTitle.text = (item!["productName"] as! String)
        
        if item!["price"] is String {
            print("Yes, it's a String")

            cell.lblPrice.text = "$ "+(item!["price"] as! String)

        } else if item!["price"] is Int {
            print("It is Integer")
                        
            let x2 : Int = (item!["price"] as! Int)
            let myString2 = String(x2)
            cell.lblPrice.text = "$ "+myString2
                        
        } else {
            print("i am number")
                        
            let temp:NSNumber = item!["price"] as! NSNumber
            let tempString = temp.stringValue
            cell.lblPrice.text = "$ "+tempString
        }
        
        cell.imgProductImage.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    
}

extension COrderDetails: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CSelectedOrderDetailsId") as? CSelectedOrderDetails
        push!.dictGetProductDetails = item as NSDictionary?
        push!.productCategoryName = strTitleIs
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // MARK:- DISMISS KEYBOARD -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.clView {
            self.view.endEditing(true)
        }
    }
    
}

extension COrderDetails: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        var sizes: CGSize
                
        let result = UIScreen.main.bounds.size
        //NSLog("%f",result.height)
        
        
        if result.height == 480 {
            sizes = CGSize(width: 190, height: 220)
        }
        else if result.height == 568 {
            sizes = CGSize(width: 80, height: 170)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: 120, height: 190)
        }
        else
        {
            sizes = CGSize(width: self.view.frame.size.width, height: 350)
        }
        
        
        return sizes
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        
        
        
        
        let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return 4
        } else if result.height == 812.000000 { // 11 pro
            return 4
        } else {
            return 10
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // var sizes: CGSize
              
        
         
        
        let result = UIScreen.main.bounds.size
        if result.height == 667.000000 { // 8
            return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else if result.height == 736.000000 { // 8 plus
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else if result.height == 896.000000 { // 11 plus
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        } else if result.height == 812.000000 { // 11 pro
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        
            
    }
    
}
