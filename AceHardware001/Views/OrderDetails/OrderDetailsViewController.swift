//
//  OrderDetailsViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 12/5/23.
//

import UIKit

class OrderDetailsViewController: UIViewController {
    
    var storyboardIdentifier = ""
    var user = [User]()
    var order = [Order]()
    var isAdmin: Bool?
    
    
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderDescriptionLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//      set values
        
        orderNameLabel.text = order[0].orderName
        orderDateLabel.text = order[0].orderDate
        orderDescriptionLabel.text = order[0].orderDescription
        customerNameLabel.text = order[0].customerName
        addressLabel.text = order[0].address
        phoneNumberLabel.text = order[0].phoneNumber
        orderStatusLabel.text = order[0].orderStatus
        
    }
    

    @IBAction func goBack(_ sender: Any) {
        if isAdmin!{
            let controller = storyboard?.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! AdminOrderNavViewController
            
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
            
        }else{
            let controller = storyboard?.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! CustomerOrdersNavigationViewController
            let orderDetailsViewController = controller.topViewController as! CustomerOrdersViewController
            
            orderDetailsViewController.user = self.user
            
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
        }
    }
    

}
