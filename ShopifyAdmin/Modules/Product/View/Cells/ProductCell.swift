//
//  ProductCell.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!

    @IBOutlet weak var deleteBtn: UIButton!
    
    var deleteProduct: (()->())?
    var editProduct: (()->())?
    
    @IBAction func editProduct(_ sender: UIButton) {
        editProduct?()
    }
    
    @IBAction func deleteProduct(_ sender: UIButton) {
        deleteProduct?()
    }
 
    
    override func layoutSublayers(of layer: CALayer) {
        
        super.layoutSubviews()
    
        
        self.layer.cornerRadius = 20
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))

        
        }
}
