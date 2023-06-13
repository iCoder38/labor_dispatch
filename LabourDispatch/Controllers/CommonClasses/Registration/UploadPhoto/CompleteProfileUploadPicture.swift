//
//  CompleteProfileUploadPicture.swift
//  ComplyBag
//
//  Created by Apple on 09/01/21.
//

import UIKit
import Alamofire

class CompleteProfileUploadPicture: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // ***************************************************************** // nav
                    
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
            }
        }
            
        @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = UPLOAD_IMAGE_PAGE_NAVIGATION_TITLE
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    var imageStr1:String!
    var imgData1:Data!
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.layer.cornerRadius = 80
            imgProfile.clipsToBounds = true
        }
    }
    
    // 217 88 40
    @IBOutlet weak var btnCamera:UIButton! {
        didSet {
            Dishu.buttonStyle(button: btnCamera, bCornerRadius: 22, bBackgroundColor: UIColor(red: 81.0/255.0, green: 158.0/255.0, blue: 238.0/255.0, alpha: 1), bTitle: uploadprofilePage_TEXT_Camera, bTitleColor: .white)
        }
    }
    @IBOutlet weak var btnGallery:UIButton! {
        didSet {
            Dishu.buttonStyle(button: btnGallery, bCornerRadius: 22, bBackgroundColor: UIColor(red: 217.0/255.0, green: 88.0/255.0, blue: 40.0/255.0, alpha: 1), bTitle: uploadprofilePage_TEXT_Gallery, bTitleColor: .white)
        }
    }
    
    @IBOutlet weak var btnSkipForNow:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
        
        self.btnCamera.addTarget(self, action: #selector(cameraClickMethod), for: .touchUpInside)
        self.btnGallery.addTarget(self, action: #selector(galleryClickMethod), for: .touchUpInside)
        
        self.btnSkipForNow.addTarget(self, action: #selector(skipForNowClickmethod), for: .touchUpInside)
    }
    
    @objc func backClickMethod() {
          self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
    
    @objc func skipForNowClickmethod() {
        let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardId")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    @objc func cameraClickMethod() {
        self.openCamera1()
    }
    
    @objc func galleryClickMethod() {
        self.openGallery1()
    }
    
       
       @objc func openCamera1() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .camera;
           imagePicker.allowsEditing = false
           self.present(imagePicker, animated: true, completion: nil)
           
       }
       
       @objc func openGallery1() {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.sourceType = .photoLibrary;
           imagePicker.allowsEditing = false
           self.present(imagePicker, animated: true, completion: nil)
           
       }
       
       internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
        // let indexPath = IndexPath.init(row: 0, section: 0)
        // let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
        
        imgProfile.isHidden = false
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imgProfile.image = image_data // show image on profile
        let imageData:Data = image_data!.pngData()!
        imageStr1 = imageData.base64EncodedString()
        self.dismiss(animated: true, completion: nil)
        imgData1 = image_data!.jpegData(compressionQuality: 0.2)!
               //print(type(of: imgData)) // data
               
        self.imageStr1 = "1"
           
           
        self.completeProfilePic()
        
       }
    
    @objc func completeProfilePic() {
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
          //Set Your URL
           let api_url = APPLICATION_BASE_URL
           guard let url = URL(string: api_url) else {
               return
           }

            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
            // let str:String = person["role"] as! String
           
               let x : Int = person["userId"] as! Int
               let myString = String(x)
               
               
               
               // let indexPath = IndexPath.init(row: 0, section: 0)
               // let cell = self.tbleView.cellForRow(at: indexPath) as! CEditTotalTableCell
               
               var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
               urlRequest.httpMethod = "POST"
               urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

           //Set Your Parameter
               let parameterDict = NSMutableDictionary()
               parameterDict.setValue("editprofile", forKey: "action")
               parameterDict.setValue(String(myString), forKey: "userId")
               // parameterDict.setValue(String(cell.txtUsername.text!), forKey: "fullName")
               // parameterDict.setValue(String(cell.txtPhoneNumber.text!), forKey: "contactNumber")
               // parameterDict.setValue(String(cell.txtAddress.text!), forKey: "address")
               // parameterDict.setValue(String(self.strSaveLatitude), forKey: "latitude")
               // parameterDict.setValue(String(self.strSaveLongitude), forKey: "longitude")

           //Set Image Data
           // let imgData = self.img_photo.image!.jpegData(compressionQuality: 0.5)!

           /*
            let params = EditUserWithoutImage(action: "editprofile",
            userId: String(myString),
            fullName: String(cell.txtUsername.text!),
            contactNumber: String(cell.txtPhoneNumber.text!),
            address: String(cell.txtAddress.text!))
            */
          // Now Execute
           AF.upload(multipartFormData: { multiPart in
               for (key, value) in parameterDict {
                   if let temp = value as? String {
                       multiPart.append(temp.data(using: .utf8)!, withName: key as! String)
                   }
                   if let temp = value as? Int {
                       multiPart.append("\(temp)".data(using: .utf8)!, withName: key as! String)
                   }
                   if let temp = value as? NSArray {
                       temp.forEach({ element in
                           let keyObj = key as! String + "[]"
                           if let string = element as? String {
                               multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                           } else
                               if let num = element as? Int {
                                   let value = "\(num)"
                                   multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                           }
                       })
                   }
               }
               multiPart.append(self.imgData1, withName: "image", fileName: "editProfilePicture.png", mimeType: "image/png")
           }, with: urlRequest)
               .uploadProgress(queue: .main, closure: { progress in
                   //Current upload progress of file
                   print("Upload Progress: \(progress.fractionCompleted)")
               })
               .responseJSON(completionHandler: { data in

                          switch data.result {

                          case .success(_):
                           do {
                           
                           let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                             
                               print("Success!")
                               print(dictionary)
                               
                               var dict: Dictionary<AnyHashable, Any>
                               dict = dictionary["data"] as! Dictionary<AnyHashable, Any>
                               
                                let defaults = UserDefaults.standard
                                defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            self.skipForNowClickmethod()
                            
                               ERProgressHud.sharedInstance.hide()
                               
                          }
                          catch {
                             // catch error.
                           print("catch error")
                           ERProgressHud.sharedInstance.hide()
                                 }
                           break
                               
                          case .failure(_):
                           print("failure")
                           ERProgressHud.sharedInstance.hide()
                           break
                           
                       }


               })
           
       }}
}
