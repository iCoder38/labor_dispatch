//
//  CShopNowCollectionCell.swift
//  Alien Broccoli
//
//  Created by Apple on 29/09/20.
//

import UIKit

class CShopNowCollectionCell: UICollectionViewCell {
   
    @IBOutlet weak var viewCellBG:UIView! {
        didSet {
            viewCellBG.layer.cornerRadius = 6
            viewCellBG.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgImage:UIImageView!
}
