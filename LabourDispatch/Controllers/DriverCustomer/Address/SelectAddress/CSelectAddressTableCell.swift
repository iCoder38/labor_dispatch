//
//  CSelectAddressTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class CSelectAddressTableCell: UITableViewCell {

    @IBOutlet weak var viewBG:UIView! {
        didSet {
            viewBG.layer.cornerRadius = 6
            viewBG.clipsToBounds = true
            viewBG.layer.borderColor = UIColor.lightGray.cgColor
            viewBG.layer.borderWidth = 0.8
            viewBG.backgroundColor = .clear
        }
    }
    @IBOutlet weak var lblUserName:UILabel! {
        didSet {
            lblUserName.text = "JOHN SMITH"
        }
    }
    @IBOutlet weak var lblFullAddress:UILabel! {
        didSet {
            lblFullAddress.text = "I AM ADDRESS I AM ADDRESS I AM ADDRESS I AM ADDRESS I AM ADDRESS "
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
