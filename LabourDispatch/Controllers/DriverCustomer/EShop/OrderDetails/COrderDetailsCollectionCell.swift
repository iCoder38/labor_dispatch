//
//  COrderDetailsCollectionCell.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class COrderDetailsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.cornerRadius = 0
            viewCellBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imgProductImage:UIImageView!
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblPrice:UILabel!
    
}
