//
//  LikedProductsCollectionViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 19/3/23.
//

import UIKit

class LikedProductsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    
    static let identifier = String(describing: LikedProductsCollectionViewCell.self)
    
    func setUp(product: Product){
        self.productNameLabel.text = product.productName
        self.price.text = "\(round(100 * product.price) / 100) сом"
        
        self.productImageView.layer.shadowColor = UIColor.black.cgColor
        self.productImageView.layer.shadowOffset = .zero
        self.productImageView.layer.cornerRadius = 25
        self.productImageView.layer.shadowOpacity = 0.5
        self.productImageView.image = UIImage(named: "\(product.productImageName)")
        
        self.productDescription.text = product.description
        
    }
    
}
