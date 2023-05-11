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
    @IBOutlet weak var productDetailLabel: UILabel!
    
    
    
    func setUp(product: Product ){
        productImageView.layer.cornerRadius = 15
        productNameLabel.text = product.productName
        productDetailLabel.text = product.description
        productPriceLabel.text = "\(round(100 * product.price) / 100) сом"
        productImageView.image = UIImage(named: product.productImageName)
    }
    
    
    
}
