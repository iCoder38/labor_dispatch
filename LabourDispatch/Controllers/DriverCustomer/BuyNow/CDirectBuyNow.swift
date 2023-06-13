//
//  CDirectBuyNow.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class CDirectBuyNow: UIViewController {

    // var directBuyProductDetails:NSDictionary!
    
    var productCategoryNamee:String!
    
    var productPhone:String!
    
    var productImage:String!
    var productDetails:String!
    var productQuantity:String!
    var productPrice:String!
    
    var productSubTotal:String!
    var productShipping:String!
    
    var productId:String!
    
    
    // save add to cart food
    var addInitialMutable:NSMutableArray = []
    
    
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
    
    @IBOutlet weak var btnCheckOut:UIButton! {
        didSet {
            btnCheckOut.setTitle("CHECKOUT", for: .normal)
            btnCheckOut.setTitleColor(.white, for: .normal)
            btnCheckOut.backgroundColor = .systemGreen
            btnCheckOut.layer.cornerRadius = 6
            btnCheckOut.clipsToBounds = true
        }
    }
        
    @IBOutlet weak var imgProductImage:UIImageView! {
        didSet {
            imgProductImage.layer.cornerRadius = 6
            imgProductImage.clipsToBounds = true
            imgProductImage.backgroundColor = .brown
        }
    }
    
    @IBOutlet weak var lblProductDetails:UILabel!
    @IBOutlet weak var lblProductQuantityAndPrice:UILabel!
    @IBOutlet weak var lblShippingPriceIs:UILabel!
    @IBOutlet weak var lblSubTotal:UILabel!
    
    @IBOutlet weak var lblFinalTotalPrice:UILabel!
    
    @IBOutlet weak var btnBack:UIButton! {
        didSet {
            btnBack.tintColor = .black
            btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnCheckOut.addTarget(self, action: #selector(pushToAddressPage), for: .touchUpInside)
        
        self.lblNavigationTitle.text = productCategoryNamee
        
        self.gradientNavigation()
        
        /*
         var productImage:String!
         var productDetails:String!
         var productQuantity:String!
         var productPrice:String!
         
         var productSubTotal:String!
         var productShipping:String!
         var productTotalPrice:String!
         */
        
        // print(productImage as Any)
        // print(productDetails as Any)
        // print(productQuantity as Any)
        // print(productPrice as Any)
        // print(productSubTotal as Any)
        // print(productShipping as Any)
    
        // print(productSubTotal as Any)
        
        // product image
        imgProductImage.sd_setImage(with: URL(string: productImage), placeholderImage: UIImage(named: "logo"))
        
        // details
        lblProductDetails.text = productDetails
        
        // quantity and price
        lblProductQuantityAndPrice.text = "Quantity : "+productQuantity+"\n\nPrice : $ "+productPrice
        
        // shipping
        lblShippingPriceIs.text = "$ "+productShipping
        
        
        
        
        // subtotal ( quantity * price )
        
        // sub total
        
        let a = (productPrice as NSString).floatValue
        let b = (productQuantity as NSString).floatValue
        let c = (productShipping as NSString).floatValue
        
        let multiply = a * b
        
        
        // convert sum float value into string
        let stringFloat =  String(describing: multiply)
        lblSubTotal.text = "$ "+stringFloat
        
        
        // final total price now (add shipping price in sub total price )
        let sum = multiply+c
        let stringFloatSum =  String(describing: sum)
        lblFinalTotalPrice.text = "$ "+stringFloatSum
        
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
    
    // MARK:- PUSH ( ADDRESS ) -
    @objc func pushToAddressPage() {
        
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "keyForOnlyAddress")
        defaults.setValue(nil, forKey: "keyForOnlyAddress")
        
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CSelectAddressId") as? CSelectAddress
        
        if productImage == nil {
            
            let myDictionary: [String:String] = [
                
                "productId":String(productId),
                "productImage":String(""),
                "productName":String(productDetails),
                "productPrice":String(lblFinalTotalPrice.text!),
                "productQuantity":String(productQuantity),
                "productState":String(""),
                "productCity":String(""),
                "productZipcode":String(""),
                "productAddress":String("")
                
                
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addInitialMutable.addObjects(from: res)
        } else {
            
            let myDictionary: [String:String] = [
                
                "productId":String(productId),
                "productImage":String(productImage),
                "productName":String(productDetails),
                "productPrice":String(lblFinalTotalPrice.text!),
                "productQuantity":String(productQuantity),
                "productState":String(""),
                "productCity":String(""),
                "productZipcode":String(""),
                "productAddress":String("")
                
            ]
            
            var res = [[String: String]]()
            res.append(myDictionary)
            
            self.addInitialMutable.addObjects(from: res)
        }
        
        push!.finalPriceForPaymentInAddress = String(lblFinalTotalPrice.text!)
        push!.arrBuyNowDataInMutableArray = self.addInitialMutable
        self.navigationController?.pushViewController(push!, animated: true)
    }

}
