//
//  COrderHistoryDetails.swift
//  Alien Broccoli
//
//  Created by Apple on 06/10/20.
//

import UIKit
import Alamofire

class COrderHistoryDetails: UIViewController {

    let cellReuseIdentifier = "cOrderHistoryDetailsTableCell"
    
    var productId:String!
    
    var dict: Dictionary<AnyHashable, Any> = [:]
    
    var ar : NSArray!
    
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
            lblNavigationTitle.text = "DETAILS"
        }
    }
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    // MARK:- COLLECTION VIEW SETUP -
    @IBOutlet weak var clView: UICollectionView! {
        didSet {
               //collection
            clView!.dataSource = self
            clView!.delegate = self
            clView!.backgroundColor = .white
            clView.isPagingEnabled = true
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
        
        self.orderHistoryDetailsClickMethod()
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
    
    // MARK:- WEBSERVICE ( ORDER HISTORY DETAILS ) -
    @objc func orderHistoryDetailsClickMethod() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "please wait...")
            
        self.view.endEditing(true)
             
        let params = OrderHistoryDetails(action: "purchedetail",
                                    purcheseId: String(productId))
            
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
                               
                                
                                self.dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                                
                                
                                // var ar : NSArray!
                                // ar = (JSON["data"] as! Array<Any>) as NSArray
                                // self.arrListOfAllMyOrders.addObjects(from: ar as! [Any])
                                
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

extension COrderHistoryDetails: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 // arrListOfAllMyOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        /*
         
         {
             data =     {
                 ShippingName = "Dishant Rajput";
                 ShippingPhone = 8287632340;
                 cardType = visa;
                 created = "2020-10-06 19:46:00";
                 deliveryDay = "3-4 days";
                 driverEmail = "ios@gmail.com";
                 driverImage = "";
                 driverName = "Mobile Gaming iPhone X";
                 driverPhone = 9865986434;
                 productDetails =         (
                                 {
                         Quantity = 1;
                         SKU = 878787;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>about 25 mg, depending on your&nbsp;</em>Turmeric, agar agar, carrot juice, ginger, cayenne, and CBD, all in a sweet treat? Yes, it is possible! These healthy, satisfying treats require only about 10 minutes to make, and they stay fresh in the refrigerator for up to a week</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895366_Elevem.jpg";
                         price = 90;
                         productId = 13;
                         productName = "Healthy CBD-Turmeric Sweets";
                     },
                                 {
                         Quantity = 5;
                         SKU = 44335;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>varies, depending on the potency of your CBD oil&nbsp;</em>Healthy CBD granola will fill you up with goodness. This recipe calls for wholesome organic rolled oats, hemp seeds, CBD oil, and rich dark chocolate. The base granola provides plenty of benefits, and the addition of CBD oil elevates this snack to new heights.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895708_Tweve.jpg";
                         price = 30;
                         productId = 16;
                         productName = "CBD Granola";
                     },
                                 {
                         Quantity = 1;
                         SKU = 89809;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>about 4 mg, depending on your ,</em>Toss freeze-dried raspberries, superfood seeds, CBD oil, and other wholesome ingredients into a food processor to quickly make satisfying and healthy bites that look like festive truffles and taste just as good.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601895413_Eight.jpg";
                         price = 56;
                         productId = 14;
                         productName = "CBD Raspberry Energy Bites";
                     },
                                 {
                         Quantity = 2;
                         SKU = 23443;
                         description = "<p><strong><em>CBD content:&nbsp;</em></strong><em>varies, depending on the potency of your CBD oil or extract</em>&nbsp;Yes, even your green juice can be adapted into a CBD edible. This recipe combines a list of super-healthy and surprising ingredients, including amla berry powder and cilantro, to make a refreshing CBD snack you can drink on the go.</p>
         \n";
                         image = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1601896824_Nine.jpg";
                         price = 34;
                         productId = 20;
                         productName = "Green Juice with CBD";
                     }
                 );
                 purcheseId = 48;
                 shippingAddress = "Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk";
                 shippingCity = Dwarka;
                 shippingCountry = "";
                 shippingState = Delhi;
                 shippingZipcode = 110075;
                 status = 0;
                 totalAmount = 364;
                 transactionId = "";
             };
             status = success;
         }
         (lldb)
         */
        // let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        
        // 0:
        // 1:
        // 2:
        // 3:
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellOne") as! COrderHistoryDetailsTableCell
            
            // print(self.dict as Any)
            // let item = self.arrListOfAllMyOrders[indexPath.row] as? [String:Any]
            
            // total number of products
            
            ar = ((self.dict["productDetails"] as! Array<Any>) as NSArray)
            // print(ar as Any)
            
            let item = ar[0] as? [String:Any]
            // print(item as Any)
            
            if ar.count == 0 {
                
                cell.accessoryType = .none
            } else if ar.count == 1 {
                
                cell.accessoryType = .none
            } else {
                
                cell.accessoryType = .disclosureIndicator
            }
            
            cell.lblTitle.text    = (item!["productName"] as! String)
            cell.lblCreatedAt.text    = "SKU : "+(item!["SKU"] as! String)
            
            // price
            if item!["price"] is String {
                print("Yes, it's a String")

                cell.lblPrice.text = "Price : $ "+(item!["price"] as! String)

            } else if item!["price"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item!["price"] as! Int)
                let myString2 = String(x2)
                cell.lblPrice.text = "Price : $ "+myString2
                            
            } else {
                print("i am number")
                            
                let temp:NSNumber = item!["price"] as! NSNumber
                let tempString = temp.stringValue
                cell.lblPrice.text = "Price : $ "+tempString
            }
             
            // quantity
            if item!["Quantity"] is String {
                print("Yes, it's a String")

                cell.lblQuantity.text = "Quantity : "+(item!["Quantity"] as! String)

            } else if item!["Quantity"] is Int {
                print("It is Integer")
                            
                let x2 : Int = (item!["Quantity"] as! Int)
                let myString2 = String(x2)
                cell.lblQuantity.text = "Quantity : "+myString2
                            
            } else {
                print("i am number")
                            
                let temp:NSNumber = item!["Quantity"] as! NSNumber
                let tempString = temp.stringValue
                cell.lblQuantity.text = "Quantity : "+tempString
            }
            
            
            
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "cellTwo") as! COrderHistoryDetailsTableCell
            
            cell2.lblShippingAddressHolderName.text = (self.dict["ShippingName"] as! String)
            cell2.lblShippingAddress.text           = (self.dict["shippingAddress"] as! String)
            cell2.lblShippingPhoneNumber.text       = (self.dict["ShippingPhone"] as! String)
            
            cell2.accessoryType = .none
            
            return cell2
            
        } else if indexPath.row == 2 {
            
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "cellThree") as! COrderHistoryDetailsTableCell
            
            cell3.lblShippingCardType.text      = "Card Type - "+(self.dict["cardType"] as! String)
            cell3.lblShippingInvoiceDate.text   = (self.dict["created"] as! String)
            cell3.lblShippingRedId.text         = "Red Id : "+(self.dict["transactionId"] as! String)
            
            cell3.accessoryType = .none
            
            return cell3
            
        } else if indexPath.row == 3 {
            
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "cellFour") as! COrderHistoryDetailsTableCell
            
            cell4.lblShippingCurrentStatus.text      = "In Transit" // (self.dict["cardType"] as! String)
            cell4.lblShippingExpectedDelivery.text   = "Expected Delivery : "+(self.dict["deliveryDay"] as! String)
            
            cell4.accessoryType = .none
            
            return cell4
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellFive") as! COrderHistoryDetailsTableCell
            return cell
            
        }
        
        
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
     
        if indexPath.row == 0 {
            
            ar = ((self.dict["productDetails"] as! Array<Any>) as NSArray)
            
            if ar.count == 0 {
                
            } else if ar.count == 1 {
                
            } else {
                
                let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "COrderHistoryProductDetailsId") as? COrderHistoryProductDetails
                push!.arrListOfAllProductDetails = ar
                self.navigationController?.pushViewController(push!, animated: true)
            }
            
            
        } else if indexPath.row == 3 {
            
            // (self.dict["ShippingPhone"] as! String)
            // (self.dict["ShippingName"] as! String)
            
            let nameAndPhone = "Name : "+(self.dict["driverName"] as! String)+"\n\nPhone : "+(self.dict["driverPhone"] as! String)
            
            let alert = UIAlertController(title: String("Detail"), message: String(nameAndPhone), preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Call Now", style: UIAlertAction.Style.default, handler: { action in
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { action in
                
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return UITableView.automaticDimension
    }
    
}

extension COrderHistoryDetails: UITableViewDelegate {
    
}

extension COrderHistoryDetails: UICollectionViewDelegate {
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrListOfAllMyOrders.count
    }
    
    //Write Delegate Code Here
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cOrderHistoryDetailsCollectionCell", for: indexPath as IndexPath) as! COrderHistoryDetailsCollectionCell
           
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
        
        // cell.viewCellBG.backgroundColor = .systemGreen // APP_BUTTON_COLOR
        
        // let item = arrListOfAllMyOrders[indexPath.row] as? [String:Any]
        // cell.lblTitle.text    = (item!["name"] as! String)
        // cell.imgImage.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "logo"))
        
        return cell
    }
    
}


extension COrderHistoryDetails: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }

    
    // MARK:- DISMISS KEYBOARD -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.clView {
            self.view.endEditing(true)
        }
    }
    
}
