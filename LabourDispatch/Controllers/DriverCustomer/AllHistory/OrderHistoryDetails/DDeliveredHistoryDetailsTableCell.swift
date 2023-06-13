//
//  DDeliveredHistoryDetailsTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 17/10/20.
//

import UIKit

class DDeliveredHistoryDetailsTableCell: UITableViewCell {

    // cell one
    @IBOutlet weak var viewbg:UIView! {
        didSet {
            viewbg.backgroundColor = .white
            viewbg.layer.cornerRadius = 6
            viewbg.clipsToBounds = true
            viewbg.layer.borderColor = UIColor.darkGray.cgColor
            viewbg.layer.borderWidth = 0.08
        }
    }
    
    @IBOutlet weak var imgProfile:UIImageView! {
        didSet {
            imgProfile.image = UIImage(named: "logo")
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblCreatedAt:UILabel!
    @IBOutlet weak var lblQuantity:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
    // cell two
     
    @IBOutlet weak var viewbg2:UIView! {
        didSet {
            viewbg2.backgroundColor = .white
            viewbg2.layer.cornerRadius = 6
            viewbg2.clipsToBounds = true
            viewbg2.layer.borderColor = UIColor.darkGray.cgColor
            viewbg2.layer.borderWidth = 0.08
        }
    }
    @IBOutlet weak var lblShippingAddressHolderName:UILabel!
    @IBOutlet weak var lblShippingAddress:UILabel!
    @IBOutlet weak var lblShippingPhoneNumber:UILabel!
    
    // cell three
    @IBOutlet weak var lblShippingCardType:UILabel!
    @IBOutlet weak var lblShippingInvoiceDate:UILabel!
    @IBOutlet weak var lblShippingRedId:UILabel!
    @IBOutlet weak var viewbg3:UIView! {
        didSet {
            viewbg3.backgroundColor = .white
            viewbg3.layer.cornerRadius = 6
            viewbg3.clipsToBounds = true
            viewbg3.layer.borderColor = UIColor.darkGray.cgColor
            viewbg3.layer.borderWidth = 0.08
        }
    }
    
    // cell four
    @IBOutlet weak var lblShippingCurrentStatus:UILabel!
    @IBOutlet weak var lblShippingExpectedDelivery:UILabel!
    @IBOutlet weak var viewbg4:UIView! {
        didSet {
            viewbg4.backgroundColor = .systemGreen
            viewbg4.layer.cornerRadius = 6
            viewbg4.clipsToBounds = true
            viewbg4.layer.borderColor = UIColor.darkGray.cgColor
            viewbg4.layer.borderWidth = 0.08
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
