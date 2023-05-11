//
//  OrderViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class OrderViewController: UIViewController {
    var user = [User]()
    var cartProducts = [Product]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print(cartProducts)
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
        
    }
    

}
