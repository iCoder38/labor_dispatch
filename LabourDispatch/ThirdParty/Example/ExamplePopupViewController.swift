//
//  ExamplePopupViewController.swift
//  BottomPopup
//
//  Created by Emre on 16.09.2018.
//  Copyright © 2018 Emre. All rights reserved.
//

import UIKit
import BottomPopup
import Alamofire
import SwiftyJSON

class ExamplePopupViewController: BottomPopupViewController {

    let cellReuseIdentifier = "exampleNewProductTableCel"
    
    var height: CGFloat?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
   
    var strGetDetails:String!
   
    var dynamicString:String!
    
    var arrListOfSavedCards : NSArray! // list of saved cards
    var arrListOfBanks : NSArray! // list of banks
    
    var arrTotalUser : NSArray! // list of user
    
    var addAllPriceInArraayAndThenSumAllValues:NSMutableArray = []
    
    var dictGetOrdersDetails:NSDictionary!
    var dictGetOrderedFoodDetails:NSDictionary!
    var arrayGetBuyNowData:NSMutableArray = []
    
    var arrayMuGetAddress:NSMutableArray = []
    var myCustomAddressArrayAddInFoodDetails:NSMutableArray = []
    
    var strSpecialPrice2:String!
    var strSpecialPrice:String!
    
    var finalPriceForPaymentInExamplePopup:String!
    
    var finalPriceSendTopaymentScreen:String!
    
    @IBOutlet weak var btnTitle:UIButton!
    
    @IBOutlet weak var btnConfirmAndPay:UIButton! {
        didSet {
            btnConfirmAndPay.layer.cornerRadius = 8
            btnConfirmAndPay.clipsToBounds = true
            // btnConfirmAndPay.backgroundColor = .systemGreen
            // btnConfirmAndPay.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            
            tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
            tbleView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myCustomAddressArrayAddInFoodDetails.removeAllObjects()
        
         // print(finalPriceForPaymentInExamplePopup as Any)
                
         // print(arrayMuGetAddress as Any)
         // print(myCustomAddressArrayAddInFoodDetails as Any)
         // print(arrayGetBuyNowData as Any)
        
        /*
         City = "G noida ";
         Zipcode = 201309;
         address = "Vvip homesG noida";
         addressId = 2;
         deliveryType = "Normal ";
         firstName = "deepak ";
         lastName = gupta;
         mobile = 7906703537;
         state = "Uttar pradesh";
         */
        
        /*
         productAddress = "";
         productCity = "";
         productImage = "http://demo2.evirtualservices.com/HoneyBudz/site/img/uploads/products/1598878630_1.jpg";
         productName = "Gummies\nCBD Gummies";
         productPrice = "$ 145.0";
         productQuantity = 1;
         productState = "";
         productZipcode = "";
         */
        
         if strGetDetails == "confirmAndPayNow" {
            
            btnTitle.setTitle("Confirm and Pay", for: .normal)
            
            self.btnConfirmAndPay.addTarget(self, action: #selector(confirmAndPayClickMethod), for: .touchUpInside)
            
            self.myCustomAddressArrayAddInFoodDetails.addObjects(from: arrayMuGetAddress as! [Any])
            self.myCustomAddressArrayAddInFoodDetails.addObjects(from: arrayGetBuyNowData as! [Any])
            // print(myCustomAddressArrayAddInFoodDetails as Any)
        
            
            // MARK:- GET TOTAL PRICE -
            self.totalpriceToPay()
            
         }
        
    }
    
    // MARK:- GET TOTAL PRICE FROM ITEMS -
    @objc func totalpriceToPay() {
        
        
        
        strSpecialPrice = finalPriceForPaymentInExamplePopup
        let editedText = strSpecialPrice.replacingOccurrences(of: "$ ", with: "")
        self.finalPriceSendTopaymentScreen = editedText
        
        tbleView.delegate = self
        tbleView.dataSource = self
        tbleView.reloadData()
        
        /*
        for n in 0..<self.myCustomAddressArrayAddInFoodDetails.count {
            let item = self.myCustomAddressArrayAddInFoodDetails[n] as? [String:Any]
            // print(item as Any)
            
            /*
             Optional(["productAddress": Unnamed Road, Sector 6, Sector 10 Dwarka, Dwarka, Delhi, 110075, IndiaOk, "productPrice": , "productZipcode": 110075, "productName": , "productState": Delhi, "productQuantity": , "productCity": Dwarka, "productImage": ])
             (lldb)
             */
            
            /*
            strSpecialPrice = (item!["productPrice"] as! String)
            
            // separate '$ ' from key
            let editedText = strSpecialPrice.replacingOccurrences(of: "$ ", with: "")
            strSpecialPrice2 = String(editedText)
            print(strSpecialPrice2 as Any)
            
            // convert string price to float
            let a = (strSpecialPrice2 as NSString).floatValue
             
            let b = +a
            */
            
            // price
            
            // quantity
            
            strSpecialPrice = (item!["productPrice"] as! String)
            let editedText = strSpecialPrice.replacingOccurrences(of: "$ ", with: "")
            
            let a = (editedText as NSString).floatValue
            let b = (item!["productQuantity"] as! NSString).floatValue
            
            let c = (a*b)
            
            
            self.addAllPriceInArraayAndThenSumAllValues.add(c)
        }
        
        // print(self.addAllPriceInArraayAndThenSumAllValues as Any)
        
        let objCMutableArray = NSMutableArray(array: self.addAllPriceInArraayAndThenSumAllValues)
        let swiftArray = objCMutableArray as NSArray as! [Float]
        
        let numbers = swiftArray // [1, 12, 2, 9, 27]
        let total = numbers.reduce(0, +)
        
        // sub total
        let x121 : Float = (total)
        let myString121 = String(x121)
        self.finalPriceSendTopaymentScreen =  String(describing: myString121)
        */
        
        
        
    }
    
    func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(600)
    }
    
    func getPopupTopCornerRadius() -> CGFloat {
        return topCornerRadius ?? CGFloat(10)
    }
    
    func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? true
    }
    
    
    @objc func confirmAndPayClickMethod() {
        
        let defaults = UserDefaults.standard
        
        defaults.set("ConfirmDismissSuccess", forKey: "keyConfirmAndPayClickByUser")
        
        defaults.set(self.finalPriceSendTopaymentScreen, forKey: "keyTotalpriceIs")
        
        // address
        let theTasks: [Any] = self.myCustomAddressArrayAddInFoodDetails as! [Any]
        UserDefaults.standard.set(theTasks, forKey: "keySaveAddressAndOrderDetails")
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension ExamplePopupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myCustomAddressArrayAddInFoodDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ExampleNewProductTableCel = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! ExampleNewProductTableCel
        
        cell.backgroundColor = .clear
        
        
        let item = myCustomAddressArrayAddInFoodDetails[indexPath.row] as? [String:Any]
        
        if indexPath.row == 0 {
            
            cell.img.layer.cornerRadius = 0
            cell.img.clipsToBounds = true
            cell.img.contentMode = .center
            
            cell.img.image = UIImage(systemName: "mappin.and.ellipse")
            cell.lblSubTitle.text = (item!["productAddress"] as! String)+", "+(item!["productCity"] as! String)+", "+(item!["productState"] as! String)+"\nPincode :"+(item!["productZipcode"] as! String)
        } else {
            
            cell.img.layer.cornerRadius = 30
            cell.img.clipsToBounds = true
            cell.img.contentMode = .scaleToFill
            
            cell.lblTitle.text = "Quantity : "+(item!["productQuantity"] as! String)+" | Price : "+(item!["productPrice"] as! String)
            cell.lblSubTitle.text = (item!["productName"] as! String)
            cell.img.sd_setImage(with: URL(string: (item!["productImage"] as! String)), placeholderImage: UIImage(named: "logo"))
        }
        
         
        
        
        /*
        if strGetDetails == "savedCardsFromAddMoney" {
            let item = arrListOfSavedCards[indexPath.row] as? [String:Any]
            cell.lblTitle.text = (item!["nameOnCard"] as! String)
            // print(arrListOfSavedCards as Any)
            
            let last4 = (item!["cardNumber"] as! String).suffix(4)
            cell.lblCardNumber.text = "xxxx xxxx xxxx - "+String(last4)
            
            cell.img.sd_setImage(with: URL(string: (item!["imageOnCard"] as! String)), placeholderImage: UIImage(named: "cardPlaceholder")) // my profile image
        }
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
        if strGetDetails == "savedCardsFromAddMoney" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfSavedCards[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingCardDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "savedBankList" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingBankDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "savedBankListOrderCard" {
            let defaults = UserDefaults.standard
            
            let item = arrListOfBanks[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingBankDetails")
            dismiss(animated: true, completion: nil)
        }
        else if strGetDetails == "addNewGiftSelectUsers" {
            let defaults = UserDefaults.standard
            
            let item = arrTotalUser[indexPath.row] as? [String:Any]
            defaults.set(item, forKey: "keyDoneSelectingUser")
            dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ExamplePopupViewController: UITableViewDelegate
{
    
}
