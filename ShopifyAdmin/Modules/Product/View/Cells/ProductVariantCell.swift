//
//  ProductVariantCell.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 23/06/2023.
//

import UIKit

class ProductVariantCell: UICollectionViewCell {
    @IBOutlet weak var size: UILabel!
    
    @IBOutlet weak var color: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.masksToBounds = false
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = true
        backgroundColor = .clear
        contentView.backgroundColor = .systemGray6
        
        
    }
    
}
