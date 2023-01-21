//
//  SignInViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit
import CryptoKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
    }
    
    private func viewStyle(){
        let padding: CGFloat = 15.0
        self.emailTextField.layer.cornerRadius = 15
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.emailTextField?.setPadding(left: padding, right: padding)
        
        self.passwordTextField.layer.cornerRadius = 15
        self.passwordTextField.layer.borderWidth = 1
        self.passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.passwordTextField?.setPadding(left: padding, right: padding)
        
        self.signInButton.layer.cornerRadius = 25
    }

    @IBAction func goBackButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! UIViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        if !(emailTextField.text?.isEmpty ?? true)! && !(passwordTextField.text?.isEmpty ?? true)! {
            
        }else{
            let alerController = UIAlertController(title: "Complete all fields!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
}
