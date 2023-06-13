//
//  VehicleInfo.swift
//  LabourDispatch
//
//  Created by apple on 13/05/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit
import Alamofire

class VehicleInfo: UIViewController {

    // ***************************************************************** // nav
                    
        @IBOutlet weak var navigationBar:UIView! {
            didSet {
                navigationBar.backgroundColor = NAVIGATION_COLOR
            }
        }
            
        @IBOutlet weak var btnBack:UIButton! {
            didSet {
                btnBack.tintColor = NAVIGATION_BACK_COLOR
                btnBack.isHidden = true
            }
        }
            
        @IBOutlet weak var lblNavigationTitle:UILabel! {
            didSet {
                lblNavigationTitle.text = "VEHICLE INFORMATION"
                lblNavigationTitle.textColor = NAVIGATION_TITLE_COLOR
                lblNavigationTitle.backgroundColor = .clear
            }
        }
                    
    // ***************************************************************** // nav
    
    @IBOutlet weak var tbleView: UITableView! {
        didSet {
            self.tbleView.delegate = self
            self.tbleView.dataSource = self
            self.tbleView.backgroundColor = .clear
            self.tbleView.tableFooterView = UIView.init(frame: CGRect(origin: .zero, size: .zero))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        self.btnBack.addTarget(self, action: #selector(backClickMethod), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func backClickMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func validationBeforeVechileInformation() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VehicleInfoTableCell
        
        
        
        
        
        if cell.txtVehicleCompany.text == "" {
            
            self.promptPOPUP(strTitle: "Vehicle Company")
            
        } else if cell.txtVehicleNumber.text == "" {
            
            self.promptPOPUP(strTitle: "Vehicle Number")
            
        } else if cell.txtVehicleModel.text == "" {
            
            self.promptPOPUP(strTitle: "Make")
            
        } else if cell.txtVehicleMake.text == "" {
            
            self.promptPOPUP(strTitle: "Mode")
            
        } else if cell.txtVehicleYear.text == "" {
            
            self.promptPOPUP(strTitle: "Year")
            
        } else if cell.txtVehicleTransportationType.text == "" {
            
            self.promptPOPUP(strTitle: "Transportation Type")
            
        } else {
            
            self.vechileInformationWB()
            
        }
        
        
        
        
        
        
        
    }
    
    @objc func promptPOPUP(strTitle:String) {
        
        let alert = UIAlertController(title: String(strTitle), message: String(" Should not be Empty"), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func vechileInformationWB() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VehicleInfoTableCell
        
        ERProgressHud.sharedInstance.showDarkBackgroundView(withTitle: "Please wait...")
        
        self.view.endEditing(true)
        
        if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
        
            let x : Int = person["userId"] as! Int
            let myString = String(x)
            
        let params = EditVehicleInformation(action: "editprofile",
                                            userId: String(myString),
                                            VehicleType: String(cell.txtVehicleCompany.text!),
                                            VehicleNumber: String(cell.txtVehicleNumber.text!),
                                            VehicleModle: String(cell.txtVehicleModel.text!),
                                            VehicleMake: String(cell.txtVehicleMake.text!),
                                            VehicleYear: String(cell.txtVehicleYear.text!),
                                            TranspotationType: String(cell.txtVehicleTransportationType.text!))
        
        print(params as Any)
        
        AF.request(BASE_URL_LABOUR_DISPATCH,
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
                           
                            var dict: Dictionary<AnyHashable, Any>
                            dict = JSON["data"] as! Dictionary<AnyHashable, Any>
                            
                             let defaults = UserDefaults.standard
                             defaults.setValue(dict, forKey: "keyLoginFullData")
                            
                            if let person = UserDefaults.standard.value(forKey: "keyLoginFullData") as? [String:Any] {
                                
                                if person["role"] as! String == "Member" {
                            
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CapabilitiesId")
                                    self.navigationController?.pushViewController(push, animated: true)
                                
                                } else {
                                
                                    let push = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CDashboardId")
                                    self.navigationController?.pushViewController(push, animated: true)
                                
                                }
                                
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


extension VehicleInfo: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell:VehicleInfoTableCell = tableView.dequeueReusableCell(withIdentifier: "vehicleInfoTableCell") as! VehicleInfoTableCell
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = backgroundView
        
        /*
         @IBOutlet weak var btnVechileCompany:UIButton!
         @IBOutlet weak var btnVechileYear:UIButton!
         @IBOutlet weak var btnVechileTransportationType:UIButton!
         */
        
        cell.btnVechileCompany.addTarget(self, action: #selector(vehicleCompanyClickMethod), for: .touchUpInside)
        cell.btnVechileYear.addTarget(self, action: #selector(vehicleYearClickMethod), for: .touchUpInside)
        cell.btnVechileTransportationType.addTarget(self, action: #selector(vehicleTypeClickMethod), for: .touchUpInside)
        
        cell.btnSaveAndContinue.addTarget(self, action: #selector(validationBeforeVechileInformation), for: .touchUpInside)
        
        return cell
        
    }

    @objc func vehicleCompanyClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VehicleInfoTableCell
        
        let dummyList = ["Vehicle Company", "Company 1", "Company 2"]
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            
            // self?.txtRegistrationAs.text = selctedText
            
            cell.txtVehicleCompany.text = selctedText
           
        }
        
    }
    
    @objc func vehicleYearClickMethod() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VehicleInfoTableCell
        
        RPicker.selectDate(title: "Select Date", minDate: Date(), maxDate: Date().dateByAddingYears(5), didSelectDate: {[weak self] (selectedDate) in
            // print(selectedDate.dateString("dd/MM/YYYY"))
            
            // self!.selectedDateIs = selectedDate.dateString("dd/MM/YYYY")
            cell.txtVehicleYear.text = selectedDate.dateString("dd/MM/YYYY")
            
            self?.tbleView.reloadData()
        })
        
    }
    
    @objc func vehicleTypeClickMethod() {
        
        let indexPath = IndexPath.init(row: 0, section: 0)
        let cell = self.tbleView.cellForRow(at: indexPath) as! VehicleInfoTableCell
        
        let dummyList = ["Vehicle Type", "Type 1", "Type 2"]
        RPicker.selectOption(title: "Select", cancelText: "Cancel", dataArray: dummyList, selectedIndex: 0) {[] (selctedText, atIndex) in
            
            // self?.txtRegistrationAs.text = selctedText
            
            cell.txtVehicleTransportationType.text = selctedText
           
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
        
    }
    
}

extension VehicleInfo: UITableViewDelegate {
    
}
