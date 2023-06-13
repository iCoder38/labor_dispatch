//
//  CSelectedOrderDetailsTableCell.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class CSelectedOrderDetailsTableCell: UITableViewCell {

    // cell 1
    @IBOutlet weak var imgProductImage:UIImageView!
    @IBOutlet weak var lblProductPrice:UILabel! {
        didSet {
            lblProductPrice.text = "Price : $158.49"
            lblProductPrice.textColor = .systemBlue
        }
    }
    @IBOutlet weak var btnQuantity:UIButton! {
        didSet {
            btnQuantity.setTitle(" QUANTITY ( 1 )", for: .normal)
            btnQuantity.setTitleColor(.white, for: .normal)
            btnQuantity.backgroundColor = .systemGreen
            btnQuantity.layer.cornerRadius = 6
            btnQuantity.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnBuyNow:UIButton! {
        didSet {
            btnBuyNow.setTitle("BUY NOW", for: .normal)
            btnBuyNow.setTitleColor(.white, for: .normal)
            btnBuyNow.backgroundColor = .black
            btnBuyNow.layer.cornerRadius = 6
            btnBuyNow.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var btnAddToCart:UIButton! {
        didSet {
            btnAddToCart.setTitle("Add to Cart", for: .normal)
            btnAddToCart.setTitleColor(.white, for: .normal)
            // btnAddToCart.backgroundColor = .black
            btnAddToCart.layer.cornerRadius = 6
            btnAddToCart.clipsToBounds = true
        }
    }
    
    // cell 2
    @IBOutlet weak var lblProductSKU:UILabel!
    @IBOutlet weak var lblProductShipping:UILabel!
    @IBOutlet weak var lblProductCategory:UILabel!
    @IBOutlet weak var lblProductDescription:UILabel! {
        didSet {
            lblProductDescription.text = "i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description i am description"
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
