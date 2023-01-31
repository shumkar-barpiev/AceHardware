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
        categoryLabel.text = category.categoryName
        let image = UIImage(named: category.categoryImageName)
        categoryImageView = UIImageView(image: image)
    }
    

}
