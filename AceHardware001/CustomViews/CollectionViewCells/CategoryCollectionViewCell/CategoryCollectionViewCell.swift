//
//  CategoryCollectionViewCell.swift
//  AceHardware001
//
//  Created by User on 31/1/23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    func setUp(category: Category){
        categoryImageView.layer.cornerRadius = 25
        categoryLabel.text = category.categoryName
        categoryImageView.image = UIImage(named: category.categoryImageName)
    }
    

}
