//
//  CSelectPaymentScreenTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class CSelectPaymentScreenTableCell: UITableViewCell {

    @IBOutlet weak var txtCardNumber:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtCardNumber.frame.height - 1, width: txtCardNumber.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtCardNumber.borderStyle = UITextField.BorderStyle.none
            txtCardNumber.layer.addSublayer(bottomLine)
            txtCardNumber.textAlignment = .center
            txtCardNumber.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtExpDate:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtExpDate.frame.height - 1, width: txtExpDate.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtExpDate.borderStyle = UITextField.BorderStyle.none
            txtExpDate.layer.addSublayer(bottomLine)
            txtExpDate.textAlignment = .center
            txtExpDate.keyboardType = .numberPad
        }
    }
    @IBOutlet weak var txtCVV:UITextField! {
        didSet {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: txtCVV.frame.height - 1, width: txtCVV.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor.systemGray2.cgColor
            txtCVV.borderStyle = UITextField.BorderStyle.none
            txtCVV.layer.addSublayer(bottomLine)
            txtCVV.textAlignment = .center
            txtCVV.keyboardType = .numberPad
            txtCVV.isSecureTextEntry = true
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
