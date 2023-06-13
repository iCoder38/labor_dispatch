
//

import UIKit
import CoreLocation

// MARK:- BASE URL -
let BASE_URL_THE_GLOBAL_HAIR = "https://www.demo2.evirtualservices.co/hair/site/services/index/"

// 207,231,244
let NAVIGATION_COLOR = UIColor.init(red: 207.0/255.0, green: 231.0/255.0, blue: 244.0/255.0, alpha: 1)// UIColor.init(red: 43.0/255.0, green: 100.0/255.0, blue: 191.0/255.0, alpha: 1)

let APP_BASIC_COLOR = UIColor.init(red: 237.0/255.0, green: 186.0/255.0, blue: 204.0/255.0, alpha: 1)


let BUTTON_COLOR_BLUE = UIColor.init(red: 43.0/255.0, green: 100.0/255.0, blue: 191.0/255.0, alpha: 1)


let NAVIGATION_TITLE_COLOR = UIColor.black
let NAVIGATION_BACK_COLOR = UIColor.black
let CART_COUNT_COLOR = UIColor.black

// URLs
let URL_HARILOSS_SUPPORT_GROUP  = "https://www.google.co.in"
let URL_MEDICAL_BILLING         = "https://www.google.co.in"
let URL_WING_CUSTOMIZATION      = "https://www.google.co.in"
let URL_WING_DRY_CLEANING       = "https://www.google.co.in"
let URL_WING_ALTERNATION        = "https://www.google.co.in"


let THE_GLOBAL_HAIR_TERMS        = "https://www.google.co.in"
let THE_GLOBAL_HAIR_PRIVACY        = "https://www.google.co.in"








let ALERT_MESSAGE       = "Alert!"

// SERVER ISSUE
let SERVER_ISSUE_TITLE          = "Server Issue."
let SERVER_ISSUE_MESSAGE        = "Server Not Responding. Please check your Internet Connection."
let SERVER_ISSUE_MESSAGE_TWO    = "Please contact to Server Admin."



class Utils: NSObject {
    
    class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController) {
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show(viewController, sender: self)
        
    }
    
    // button
    class func textFieldUI(textField:UITextField,tfName:String,tfCornerRadius:CGFloat,tfpadding:CGFloat,tfBorderWidth:CGFloat,tfBorderColor:UIColor,tfAppearance:UIKeyboardAppearance,tfKeyboardType:UIKeyboardType,tfBackgroundColor:UIColor,tfPlaceholderText:String) {
        textField.text = tfName
        textField.layer.cornerRadius = tfCornerRadius
        textField.clipsToBounds = true
        textField.setLeftPaddingPoints(tfpadding)
        textField.layer.borderWidth = tfBorderWidth
        textField.layer.borderColor = tfBorderColor.cgColor
        textField.keyboardAppearance = tfAppearance
        textField.keyboardType = tfKeyboardType
        textField.backgroundColor = tfBackgroundColor
        textField.placeholder = tfPlaceholderText
    }
    
}


extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.subAdministrativeArea,$0?.first?.locality,$0?.first?.subLocality, $1) }
    }
    
    func countryCode(completion: @escaping (_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.isoCountryCode, $1) }
    }
    
    func fullAddressFull(completion: @escaping (_ city: String?,_ country: String?, _ zipcode:  String?, _ localAddress:  String?, _ locality:  String?, _ subLocality:  String?,_ countryCodeIs:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality,$0?.first?.country, $0?.first?.postalCode,$0?.first?.administrativeArea,$0?.first?.locality,$0?.first?.subLocality,$0?.first?.isoCountryCode, $1) }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension Date {
    
    func dateString(_ format: String = "MMM-dd-YYYY, hh:mm a") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}
