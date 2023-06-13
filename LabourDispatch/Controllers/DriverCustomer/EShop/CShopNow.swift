//
//  CShopNow.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit
import Alamofire

class CShopNow: UIViewController {
    
    var dashboardTitle = ["CBD Oil","CBD Gummies","CBD Capsules","CBD Topicals","CBD Candy","CBD Edibles"]
    var dashboardImage = ["1","2","3","4","5","6"]
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    @IBOutlet weak var lblCartCount:UILabel! {
        didSet {
            self.lblCartCount.isHidden = true
        }
    }
    
    @IBOutlet weak var indicatorr:UIActivityIndicatorView! {
        didSet {
            indicatorr.color = .white
        }
    }
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "SHOP NOW"
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
            btnMenu.tintColor = .white
        }
    }
    
    @IBOutlet weak var btnCart:UIButton! {
        didSet {
            btnCart.backgroundColor = .clear
            btnCart.tintColor = .black
            btnCart.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnMenu.addTarget(self, action: #selector(sidebackBarMenuClick), for: .touchUpInside)
        self.btnCart.addTarget(self, action: #selector(cartClickMwthod), for: .touchUpInside)
        
        self.gradientNavigation()
        
        // self.sideBarMenuClick()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.categoriesWB()
        
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
    
    @objc func sidebackBarMenuClick() {
        
        self.navigationController?.popViewController(animated: true)
        
        /*
        if revealViewController() != nil {
            btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
               
            revealViewController().rearViewRevealWidth = 300
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        */
    }
    
}


extension CShopNow: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    //Write Delegate Code Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cShopNowCollectionCell", for: indexPath as IndexPath) as! CShopNowCollectionCell
           
        /*
         SubCat =             (
         );
         id = 1;
         image = "";
         name = "CBD OIL";
         */
        
        // MARK:- CELL CLASS -
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.6
        
        cell.viewCellBG.backgroundColor = .systemGreen // APP_BUTTON_COLOR
        
        let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        cell.lblTitle.text    = (item!["name"] as! String)
        cell.imgImage.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
    // MARK:- WEBSERVICE ( CATEGORIES ) -
    @objc func categoriesWB() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        self.arrListOfAllMyOrders.removeAllObjects()
        
        self.view.endEditing(true)
        
        let forgotPasswordP = ShopNowParam(action: "category")
        
        AF.request(BASE_URL_ALIEN_BROCCOLI,
                   method: .post,
                   parameters: forgotPasswordP,
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
                            
                            self.clView.delegate = self
                            self.clView.dataSource = self
                            self.clView.reloadData()
                            
                            self.totalItemsInCart()
                            self.indicatorr.startAnimating()
                            
                            
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
                            
                            // cart
                            
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
                            
                            self.indicatorr.stopAnimating()
                            self.indicatorr.hidesWhenStopped = true
                            
                            /*
                            if JSON["TotalCartItem"] is String {
                                print("Yes, it's a String")

                                self.lblCartCount.text = ""

                            } else if JSON["TotalCartItem"] is Int {
                                print("It is Integer")
                                            
                                let x2 : Int = (JSON["TotalCartItem"] as! Int)
                                let myString2 = String(x2)
                                self.lblCartCount.text = myString2
                                            
                            } else {
                                print("i am number")
                                            
                                let temp:NSNumber = JSON["TotalCartItem"] as! NSNumber
                                let tempString = temp.stringValue
                                self.lblCartCount.text = tempString
                            }
                            */
                            
                            
                            
                        } else {
                            print("no")
                            ERProgressHud.sharedInstance.hide()
                            
                            self.indicatorr.stopAnimating()
                            self.indicatorr.hidesWhenStopped = true
                            
                            var strSuccess2 : String!
                            strSuccess2 = JSON["msg"]as Any as? String
                            
                            Utils.showAlert(alerttitle: String(strSuccess), alertmessage: String(strSuccess2), ButtonTitle: "Ok", viewController: self)
                            
                        }
                        
                    case let .failure(error):
                        print(error)
                        ERProgressHud.sharedInstance.hide()
                        
                        self.indicatorr.stopAnimating()
                        self.indicatorr.hidesWhenStopped = true
                        
                        Utils.showAlert(alerttitle: SERVER_ISSUE_TITLE, alertmessage: SERVER_ISSUE_MESSAGE, ButtonTitle: "Ok", viewController: self)
                    }
        }
        
    }
}
    
    
    
}

extension CShopNow: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderDetailsId") as? COrderDetails
        push!.productDetailsId = (item!["id"] as! Int)
        push!.strTitleIs = (item!["name"] as! String)
        self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // MARK:- DASHBOARD PUSH -
    @objc func ordersListingPage() {
         let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderDetailsId") as? COrderDetails
         self.navigationController?.pushViewController(push!, animated: true)
    }
    
    // MARK:- DISMISS KEYBOARD -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.clView {
            self.view.endEditing(true)
        }
    }
    
}

extension CShopNow: UICollectionViewDelegateFlowLayout {
    
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
            sizes = CGSize(width: 190, height: 220)
        }
        else if result.height == 667.000000 // 8
        {
            sizes = CGSize(width: 180, height: 220)
        }
        else if result.height == 736.000000 // 8 plus
        {
            sizes = CGSize(width: 180, height: 220)
        }
        else if result.height == 812.000000 // 11 pro
        {
            sizes = CGSize(width: 180, height: 220)
        }
        else if result.height == 896.000000 // 11 , 11 pro max
        {
            sizes = CGSize(width: 180, height: 220)
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
            return 2
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
            return UIEdgeInsets(top: 20, left: 4, bottom: 10, right: 4)
        } else if result.height == 736.000000 { // 8 plus
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else if result.height == 896.000000 { // 11 plus
            return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        } else if result.height == 812.000000 { // 11 pro
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        
        
            
    }
    
}


class Colors {
    var gl:CAGradientLayer!

    init() {
        let colorTop = UIColor(red: 192.0 / 255.0, green: 38.0 / 255.0, blue: 42.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 35.0 / 255.0, green: 2.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0).cgColor

        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorBottom]
        self.gl.locations = [0.0, 1.0]
    }
}

