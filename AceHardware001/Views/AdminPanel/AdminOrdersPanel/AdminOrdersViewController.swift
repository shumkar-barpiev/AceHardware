//
//  AdminOrdersViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminOrdersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
}