//
//  VehicleInfoTableCell.swift
//  LabourDispatch
//
//  Created by apple on 13/05/21.
//  Copyright © 2021 Apple . All rights reserved.
//

import UIKit

class VehicleInfoTableCell: UITableViewCell {

    let textFieldBGColor = UIColor.init(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)
    
    let paddings = 20
    
    @IBOutlet weak var txtVehicleCompany:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleCompany,
                              tfName: txtVehicleCompany.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Vehicle Company")
        }
    }
    @IBOutlet weak var txtVehicleNumber:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleNumber,
                              tfName: txtVehicleNumber.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Vehicle Number")
        }
    }
    @IBOutlet weak var txtVehicleMake:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleMake,
                              tfName: txtVehicleMake.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Make")
        }
    }
    @IBOutlet weak var txtVehicleModel:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleModel,
                              tfName: txtVehicleModel.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Model")
        }
    }
    @IBOutlet weak var txtVehicleYear:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleYear,
                              tfName: txtVehicleYear.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Year")
        }
    }
    @IBOutlet weak var txtVehicleTransportationType:UITextField! {
        didSet {
            // txtPassword.isSecureTextEntry = true
            Utils.textFieldUI(textField: txtVehicleTransportationType,
                              tfName: txtVehicleTransportationType.text!,
                              tfCornerRadius: 6,
                              tfpadding: CGFloat(paddings),
                              tfBorderWidth: 0.8,
                              tfBorderColor: .lightGray,
                              tfAppearance: .dark,
                              tfKeyboardType: .default,
                              tfBackgroundColor: textFieldBGColor,
                              tfPlaceholderText: "Transportation Type")
        }
    }
    
    @IBOutlet weak var btnVechileCompany:UIButton!
    @IBOutlet weak var btnVechileYear:UIButton!
    @IBOutlet weak var btnVechileTransportationType:UIButton!
    
    @IBOutlet weak var btnSaveAndContinue:UIButton! {
        didSet {
            btnSaveAndContinue.backgroundColor = .black
            btnSaveAndContinue.setTitleColor(.white, for: .normal)
            btnSaveAndContinue.layer.cornerRadius = 6
            btnSaveAndContinue.clipsToBounds = true
            btnSaveAndContinue.setTitle("Save & Continue", for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
