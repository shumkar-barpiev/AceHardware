//
//  AdminProductListViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class AdminProductListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminListNavViewController") as! AdminListNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
}
