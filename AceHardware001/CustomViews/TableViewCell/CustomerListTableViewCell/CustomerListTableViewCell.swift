//
//  CustomerListTableViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class CustomerListTableViewCell: UITableViewCell {

    @IBOutlet weak var customerImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registeredDateLabel: UILabel!
    
    
    static let identifier = "CustomerListTableViewCell"
    
    func setUp(customer: User ){
        customerImageView.layer.cornerRadius = 15
        userNameLabel.text = customer.userName
        emailLabel.text = customer.email
        registeredDateLabel.text = customer.lastActiveDate
        if let image = UIImage(named: customer.userImageName ) {
            customerImageView.image = image
        }
    }
    
}
