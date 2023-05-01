//
//  UserUpdatePageViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 2/5/23.
//

import UIKit

class UserUpdatePageViewController: UIViewController {
    
    var user = [User]()
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(user.count > 0){
            userNameTextField.text = user[0].userName
            phoneNumberTextField.text = user[0].phoneNumber
            emailTextField.text = user[0].email
        }

    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
        controller.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func updateButtonAction(_ sender: Any) {
        print("update info")
    }
    
}
