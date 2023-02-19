//
//  ProductList TableViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 19/2/23.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {

    static let identifier = "ProductListTableViewCell"
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    func setUp(product: Product ){
        productImageView.layer.cornerRadius = 15
        productNameLabel.text = product.productName
        productPriceLabel.text = "\(product.price) $"
        productImageView.image = UIImage(named: product.productImageName)
    }
    
    
    
}
