//
//  PopupViewController.swift
//  MIBlurPopup
//
//  Created by Mario on 14/01/2017.
//  Copyright © 2017 Mario. All rights reserved.
//

import UIKit
import MIBlurPopup

class PopupViewController: UIViewController {

    var dictnotificationDetails:NSDictionary!
    
    // MARK: - IBOutlets -
    
    @IBOutlet weak var dismissButton: UIButton! {
        didSet {
            dismissButton.setTitle("Accept Job", for: .normal)
            dismissButton.layer.cornerRadius = dismissButton.frame.height/2
        }
    }
    
    @IBOutlet weak var popupContentContainerView: UIView!
    @IBOutlet weak var popupMainView: UIView! {
        didSet {
            popupMainView.layer.cornerRadius = 10
        }
    }
    
    var customBlurEffectStyle: UIBlurEffect.Style?
    var customInitialScaleAmmount: CGFloat!
    var customAnimationDuration: TimeInterval!
    
    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblPhone:UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        customBlurEffectStyle == .dark ? .lightContent : .default
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationCapturesStatusBarAppearance = true
        
        // print(dictnotificationDetails as Any)
        
        // total amount
        if dictnotificationDetails["totalAmount"] is String {
                          
            print("Yes, it's a String")
          
            self.lblPrice.text = "Price : $ "+(dictnotificationDetails["totalAmount"] as! String)

        } else if dictnotificationDetails["totalAmount"] is Int {
          
            print("It is Integer")
          
            let x2 : Int = (dictnotificationDetails["totalAmount"] as! Int)
            let myString2 = String(x2)
            self.lblPrice.text = "Price : $ "+myString2
          
        } else {
        //some other check
          print("i am ")
          
            let temp:NSNumber = dictnotificationDetails["totalAmount"] as! NSNumber
            let tempString = temp.stringValue
            self.lblPrice.text = "Price : $ "+tempString
          
        }
        
        
        
        
        
        // address
        self.lblAddress.text = (dictnotificationDetails["shippingAddress"] as! String)
        
        // name
        self.lblName.text = "Name : "+(dictnotificationDetails["userName"] as! String)
        
        // phone
        self.lblPhone.text = "Phone : "+(dictnotificationDetails["userPhone"] as! String)
    }
    
    // MARK: - IBActions -
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        // dismiss(animated: true)
        self.navigationController?.popViewController(animated: false)
    }

}

// MARK: - MIBlurPopupDelegate

extension PopupViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        popupContentContainerView ?? UIView()
    }
    
    var blurEffectStyle: UIBlurEffect.Style? {
        customBlurEffectStyle
    }
    
    var initialScaleAmmount: CGFloat {
        customInitialScaleAmmount
    }
    
    var animationDuration: TimeInterval {
        customAnimationDuration
    }
    
}
