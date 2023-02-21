//
//  ProductCollectionViewCell.swift
//  AceHardware001
//
//  Created by User on 2/2/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    static let identifier = String(describing: ProductCollectionViewCell.self)
    
    func setUp(product: Product){
        productImageView.image = UIImage(named: product.productImageName)
        productNameLabel.text = product.productName
        productPriceLabel.text = "\(round(100 * product.price) / 100) som"
    }
    
    
}
