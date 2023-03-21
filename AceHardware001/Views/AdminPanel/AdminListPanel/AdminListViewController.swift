//
//  AdminListViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    @IBAction func customersButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminCustomerListNavViewController") as! AdminCustomerListNavViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    @IBAction func categoryButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminCategoryListNavViewController") as! AdminCategoryListNavViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    @IBAction func productButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminProductListNavViewController") as! AdminProductListNavViewController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
}
