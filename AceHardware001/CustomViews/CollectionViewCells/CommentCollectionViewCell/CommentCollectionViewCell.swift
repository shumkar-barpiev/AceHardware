//
//  CommentCollectionViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 13/3/23.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentBodyLabel: UILabel!
    @IBOutlet weak var userNameImageView: UIImageView!
    
    static let identifier = String(describing: CommentCollectionViewCell.self)
    
    func setUp(comment: Comment){
        userNameLabel.text = comment.userName
        userNameImageView.image = UIImage(named: comment.userImageName)
        dateLabel.text = comment.date
        commentBodyLabel.text = comment.commentBody
    }
    
}
