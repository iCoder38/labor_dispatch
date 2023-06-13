//
//  CTotalCartListTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 05/10/20.
//

import UIKit

class CTotalCartListTableCell: UITableViewCell {

    @IBOutlet weak var imgProductImage:UIImageView!
    
    @IBOutlet weak var lblProductDetails:UILabel!
    @IBOutlet weak var lblProductQuantityAndPrice:UILabel!
    
    @IBOutlet weak var btnDeleteItem:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
