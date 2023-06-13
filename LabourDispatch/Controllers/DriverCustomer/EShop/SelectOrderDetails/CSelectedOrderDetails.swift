//
//  CSelectedOrderDetails.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

import Alamofire
class CSelectedOrderDetails: UIViewController {

    let cellReuseIdentifier = "cSelectedOrderDetailsTableCell"
    
    var strTitleIss:String!
    
    var dictGetProductDetails:NSDictionary!
    var productCategoryName:String!
    
    var productQuantity:String!
    var productQuantityWithTextSaved:String!
    
    // save total quantity list
    var totalQuantityMutArrau:NSMutableArray! = []
    
    // MARK:- ARRAY -
    var arrListOfAllMyOrders:NSMutableArray! = []
    var page : Int! = 1
    var loadMore : Int! = 1
    
    // MARK:- SELECT GENDER -
    let regularFont = UIFont.systemFont(ofSize: 16)
    let boldFont = UIFont.boldSystemFont(ofSize: 16)
    
    // MARK:- CUSTOM NAVIGATION BAR -
    @IBOutlet weak var navigationBar:UIView! {
        didSet {
            navigationBar.backgroundColor = NAVIGATION_BACKGROUND_COLOR
        }
    }

    // MARK:- CUSTOM NAVIGATION TITLE -
    @IBOutlet weak var lblNavigationTitle:UILabel! {
        didSet {
            lblNavigationTitle.text = "CBD Oil"
        }
    }
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
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
    
    @IBOutlet weak var btnAddToCart:UIButton!
    
    // MARK:- TABLE VIEW -
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.backgroundColor = .white
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(dictGetProductDetails as Any)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnCart.addTarget(self, action: #selector(cartClickMwthod), for: .touchUpInside)
        
        self.lblNavigationTitle.text = productCategoryName
        
        self.gradientNavigation()
        
        self.productQuantityWithTextSaved = "1"
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.totalItemsInCart()
    }
    
    @objc func cartClickMwthod() {
        
        let settingsVCId = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CTotalCartListId") as? CTotalCartList
        self.navigationController?.pushViewController(settingsVCId!, animated: true)
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
    
    
    
    
    
    // MARK:- WEBSERVICE ( ADD TO CART ) -
        @objc func addItemInCart() {
             ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
            
            self.view.endEditing(true)
            
             if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
             let x : Int = (person["userId"] as! Int)
             let myString = String(x)
                
                // productId
                
                let x2 : Int = (dictGetProductDetails["productId"] as! Int)
                let myString2 = String(x2)
                
                let params = AddToCart(action: "addcart",
                                       userId: String(myString),
                                       quantity: String(productQuantityWithTextSaved),
                                       productId: String(myString2))
            
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
                                
                                let x : Int = JSON["totalCartItem"] as! Int
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


extension CSelectedOrderDetails: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 //arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        
          // print(productQuantity as Any)
         print(dictGetProductDetails as Any)
        
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
        
        
        if indexPath.row == 0 {
            
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! CSelectedOrderDetailsTableCell
            
            // product image
            cell1.imgProductImage.sd_setImage(with: URL(string: dictGetProductDetails!["image"] as! String), placeholderImage: UIImage(named: "logo"))
            
            cell1.btnQuantity.addTarget(self, action: #selector(selectQuantityClickMethod), for: .touchUpInside)
            cell1.btnBuyNow.addTarget(self, action: #selector(directBuyNowClickMethod), for: .touchUpInside)
            cell1.btnAddToCart.addTarget(self, action: #selector(addItemInCart), for: .touchUpInside)
            
            // price
            if dictGetProductDetails!["price"] is String {
                print("Yes, it's a String")

                cell1.lblProductPrice.text = "Price : $"+(dictGetProductDetails!["price"] as! String)

            } else if dictGetProductDetails!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["price"] as! Int)
                let myString2 = String(x2)
                cell1.lblProductPrice.text = "Price : $"+myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["price"] as! NSNumber
                let tempString = temp.stringValue
                cell1.lblProductPrice.text = "Price : $"+tempString
                
            }
            
            
            
            // quantity
            if dictGetProductDetails!["quantity"] is String {
                print("Yes, it's a String")

                if productQuantityWithTextSaved == "0" {
                    
                    cell1.btnQuantity.setTitle("Quantity", for: .normal)
                } else {
                    
                    cell1.btnQuantity.setTitle("Quantity ("+productQuantityWithTextSaved+")", for: .normal)
                }
                
                self.productQuantity = (dictGetProductDetails!["quantity"] as! String)
                
            } else if dictGetProductDetails!["quantity"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["quantity"] as! Int)
                let myString2 = String(x2)
                // cell1.btnQuantity.setTitle("Quantity ("+myString2+")", for: .normal)
                
                if productQuantityWithTextSaved == "0" {
                    
                    cell1.btnQuantity.setTitle("Quantity", for: .normal)
                } else {
                    
                    cell1.btnQuantity.setTitle("Quantity ("+productQuantityWithTextSaved+")", for: .normal)
                }
                
                self.productQuantity = myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["quantity"] as! NSNumber
                let tempString = temp.stringValue
                // cell1.btnQuantity.setTitle("Quantity ("+tempString+")", for: .normal)
                
                if productQuantityWithTextSaved == "0" {
                    
                    cell1.btnQuantity.setTitle("Quantity", for: .normal)
                } else {
                    
                    cell1.btnQuantity.setTitle("Quantity ("+productQuantityWithTextSaved+")", for: .normal)
                }
                
                self.productQuantity = tempString
            }
            
            // cell1.btnQuantity.addTarget(self, action: #selector(quantityClickMethod), for: .touchUpInside)
            
            return cell1
        } else {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! CSelectedOrderDetailsTableCell
            
            cell2.lblProductSKU.text      = (dictGetProductDetails!["SKU"] as! String)
            cell2.lblProductShipping.text   = "Free Shipping"
            cell2.lblProductCategory.text   = String(productCategoryName)
            // cell2.lblProductDescription.text = (dictGetProductDetails!["description"] as! String)
            
            let htmlString = "<span style=\"font-family: Avenier-Next; font-size: 16.0\">\((dictGetProductDetails!["description"] as! String) )</span>"
            let data = htmlString.data(using: String.Encoding.unicode)! // mind "!"
            let attrStr = try? NSAttributedString( // do catch
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            // suppose we have an UILabel, but any element with NSAttributedString will do
            cell2.lblProductDescription.attributedText = attrStr
            
            return cell2
        }
        
        // return cell
    }

    @objc func quantityClickMethod() {
        
        
        
        
        
        
        
        let values = ["1", "2", "3", "4"]
        DPPickerManager.shared.showPicker(title: "quantity", selected: "1", strings: values) { (value, index, cancel) in
            if !cancel {
                // TODO: you code here
                debugPrint(value as Any)
            }
        }
        
    }
    
    @objc func directBuyNowClickMethod() {
        
         if self.productQuantityWithTextSaved == "0" {
            
            let alert = UIAlertController(title: String("Select Quantity"), message: String("Please select atleast one quantity of this product."), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                 
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
         
            let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDirectBuyNowId") as? CDirectBuyNow
            
            // price
            if dictGetProductDetails!["price"] is String {
                print("Yes, it's a String")

                push!.productPrice = (dictGetProductDetails!["price"] as! String)

            } else if dictGetProductDetails!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["price"] as! Int)
                let myString2 = String(x2)
                push!.productPrice = myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["price"] as! NSNumber
                let tempString = temp.stringValue
                push!.productPrice = tempString
                
             }
            
            
            
            
            // product name
            push!.productDetails = (dictGetProductDetails!["productName"] as! String)+"\n"+(dictGetProductDetails!["cateroryName"] as! String)
            
            // product image
            push!.productImage = (dictGetProductDetails!["image"] as! String)
            
            // shipping charge
            push!.productShipping = "0" // (dictGetProductDetails!["image"] as! String)
            
            // product id
            let x233 : Int = (dictGetProductDetails!["productId"] as! Int)
            let myString233 = String(x233)
            push!.productId = myString233
            
            // quantity
            push!.productQuantity = productQuantityWithTextSaved
            
            // phone number
            
            
            // sub total
            if dictGetProductDetails!["price"] is String {
                print("Yes, it's a String")

                push!.productSubTotal = (dictGetProductDetails!["price"] as! String)

            } else if dictGetProductDetails!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (dictGetProductDetails!["price"] as! Int)
                let myString2 = String(x2)
                push!.productSubTotal = myString2
                
            } else {
                print("i am number")
                            
                let temp:NSNumber = dictGetProductDetails!["price"] as! NSNumber
                let tempString = temp.stringValue
                push!.productSubTotal = tempString
                
             }
            
            push!.productCategoryNamee = productCategoryName
            self.navigationController?.pushViewController(push!, animated: true)
        }
        
    }
    
     // MARK:- QUANTITY LIST -
     @objc func selectQuantityClickMethod(_ sender:UIButton) {
        
        self.totalQuantityMutArrau.removeAllObjects()
        
        if productQuantity == "0" {
            
            // quantity is zero. so you can not order this item
        } else {
            
             let myString1 = productQuantity
             let myInt1 = Int(myString1!)
            
            for qList in 1..<(myInt1)!+1 {
                
                // convert int quantity to string then save to nutable array
                let x : Int = qList
                let myString = String(x)
                
                
                totalQuantityMutArrau.add(myString)
            }
            
            
             let redAppearance = YBTextPickerAppearanceManager.init(
                 pickerTitle         : "Select Quantity",
                 titleFont           : boldFont,
                 titleTextColor      : .white,
                 titleBackground     : .systemGreen,
                 searchBarFont       : regularFont,
                 searchBarPlaceholder: "search quantity",
                 closeButtonTitle    : "Cancel",
                 closeButtonColor    : .darkGray,
                 closeButtonFont     : regularFont,
                 doneButtonTitle     : "Okay",
                 doneButtonColor     : sender.backgroundColor,
                 doneButtonFont      : boldFont,
                 checkMarkPosition   : .Right,
                 itemCheckedImage    : UIImage(named:"red_ic_checked"),
                 itemUncheckedImage  : UIImage(named:"red_ic_unchecked"),
                 itemColor           : .black,
                 itemFont            : regularFont
             )
             
            // MARK:- CONVERT MUTABLE ARRAY TO ARRAY -
            let array: [String] = totalQuantityMutArrau.copy() as! [String]
            
            let arrGender = array
            let picker = YBTextPicker.init(with: arrGender, appearance: redAppearance,
                                           onCompletion: { (selectedIndexes, selectedValues) in
                                            if let selectedValue = selectedValues.first{
                                                if selectedValue == arrGender.last!{
                                                     
                                                    self.productQuantityWithTextSaved = "\(selectedValue)"
                                                    
                                                    self.tbleView.reloadData()
                                                    
                                                 } else {
                                                     
                                                    self.productQuantityWithTextSaved = "\(selectedValue)"
                                                    
                                                    self.tbleView.reloadData()
                                                 }
                                             } else {
                                                 // self.btnGenderPicker.setTitle("What's your gender?", for: .normal)
                                                 // cell.txtSelectGender.text = "What's your gender?"
                                                
                                                print()
                                                
                                             }
             },
                                            onCancel: {
                                                print("Cancelled")
             })
             
            picker.show(withAnimation: .FromBottom)
        }
        
    }
     
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
         
        
         
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            
            return 420
        } else {
            
            return UITableView.automaticDimension
        }
    }
    
}

extension CSelectedOrderDetails: UITableViewDelegate {
    
}
