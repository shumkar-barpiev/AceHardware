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
    @IBOutlet weak var isAdminLabel: UILabel!
    
    
    
    static let identifier = "CustomerListTableViewCell"
    
    func setUp(customer: User ){
        userNameLabel.text = customer.userName
        emailLabel.text = customer.email
        registeredDateLabel.text = customer.lastActiveDate
        customerImageView.image =  UIImage(named: customer.userImageName ) ?? UIImage(systemName: "person")
        
        if customer.isAdmin == 1{
            isAdminLabel.text = "Admin"
        }else{
            isAdminLabel.text = "Customer"
        }
        
    }
    
}
