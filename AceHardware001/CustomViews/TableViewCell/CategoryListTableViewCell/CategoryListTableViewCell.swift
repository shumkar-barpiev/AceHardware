//
//  CategoryListTableViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class CategoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryDescription: UILabel!
    
    static let identifier = "CategoryListTableViewCell"
    
    func setUp(category: Category ){
        categoryName.text = category.categoryName
        categoryDescription.text = category.categoryDescription
        categoryImageView.image = UIImage(named: category.categoryImageName)
    }
}
