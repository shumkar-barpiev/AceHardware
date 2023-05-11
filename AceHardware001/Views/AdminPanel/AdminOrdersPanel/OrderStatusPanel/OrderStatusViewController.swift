//
//  OrderStatusViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class OrderStatusViewController: UIViewController {

    var order = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(order)
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminOrderNavViewController") as! AdminOrderNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        
    }
    

}
