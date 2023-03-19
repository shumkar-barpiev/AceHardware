//
//  SuggestionsCollectionViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 28/2/23.
//

import UIKit

class SuggestionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryDescriptionLabel: UILabel!
    
    @IBOutlet weak var lookButtonLabel: UILabel!
    
    
    static let identifier = "SuggestionsCollectionViewCell"
    
    func setUp(category: Category){
        categoryImageView.layer.cornerRadius = 25
        categoryImageView.image = UIImage(named: category.categoryImageName)
        categoryNameLabel.text = category.categoryName
        categoryDescriptionLabel.text = category.categoryDescription
        lookButtonLabel.layer.masksToBounds = true
        lookButtonLabel.layer.cornerRadius = 15
        
    }
    
}
