//
//  CreateAccountViewController.swift
//  AceHardware001
//
//  Created by User on 13/12/22.
//

import UIKit

class CreateAccountViewController: UIViewController {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        
    }
    
    private func viewStyle(){
        let padding: CGFloat = 15.0

        self.usernameTextField.layer.cornerRadius = 15
        self.usernameTextField.layer.borderWidth = 1
        self.usernameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.usernameTextField?.setPadding(left: padding, right: padding)
        
        self.phoneNumberTextField.layer.cornerRadius = 15
        self.phoneNumberTextField.layer.borderWidth = 1
        self.phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.phoneNumberTextField?.setPadding(left: padding, right: padding)
        
        self.emailTextField.layer.cornerRadius = 15
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailTextField?.setPadding(left: padding, right: padding)
        
        self.passwordTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordTextField?.setPadding(left: padding, right: padding)
        
        self.createButton.layer.cornerRadius = 25
    }

}
