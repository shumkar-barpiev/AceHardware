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
    @IBOutlet weak var lookButton: UIButton!
    
    static let identifier = "SuggestionsCollectionViewCell"
    
    func setUp(category: Category){
        categoryImageView.layer.cornerRadius = 25
        categoryImageView.image = UIImage(named: category.categoryImageName)
        categoryNameLabel.text = category.categoryName
        categoryDescriptionLabel.text = category.categoryDescription
        lookButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func lookButtonAction(_ sender: Any) {
        print(categoryNameLabel.text)
        
    }
    
    
}
