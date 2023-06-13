//
//  CAddNewAddressTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 03/10/20.
//

import UIKit

class CAddNewAddressTableCell: UITableViewCell {

    @IBOutlet weak var txtFirstName:UITextField! {
        didSet {
            txtFirstName.placeholder = "first name..."
        }
    }
    @IBOutlet weak var txtLastName:UITextField! {
        didSet {
            txtLastName.placeholder = "last name..."
        }
    }
    @IBOutlet weak var txtMobileNumber:UITextField! {
        didSet {
            txtMobileNumber.placeholder = "mobile number..."
        }
    }
    @IBOutlet weak var txtaddressLine1:UITextField! {
        didSet {
            txtaddressLine1.placeholder = "address..."
        }
    }
    @IBOutlet weak var txtaddressLine2:UITextField! {
        didSet {
            txtaddressLine2.placeholder = "address line 2..."
        }
    }
    @IBOutlet weak var txtCity:UITextField! {
        didSet {
            txtCity.placeholder = "city..."
        }
    }
    @IBOutlet weak var txtPinCode:UITextField! {
        didSet {
            txtPinCode.placeholder = "pin code..."
        }
    }
    @IBOutlet weak var txtCountry:UITextField! {
        didSet {
            txtCountry.placeholder = "country..."
        }
    }
    @IBOutlet weak var txtState:UITextField! {
        didSet {
            txtState.placeholder = "state..."
        }
    }
    @IBOutlet weak var txtCompany:UITextField! {
        didSet {
            txtCompany.placeholder = "company..."
        }
    }
    
    @IBOutlet weak var btnSaveAddress:UIButton! {
        didSet {
            btnSaveAddress.layer.cornerRadius = 4
            btnSaveAddress.clipsToBounds = true
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
