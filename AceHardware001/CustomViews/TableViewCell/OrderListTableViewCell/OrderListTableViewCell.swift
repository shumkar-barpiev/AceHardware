//
//  OrderListTableViewCell.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    static let identifier = "OrderListTableViewCell"
    
    
    func setUp(order: Order ){
        orderNameLabel.text = order.orderName
        orderStatusLabel.text = "Status: " + order.orderStatus
    }
}
