//
//  ViewController.swift
//  AceHardware001
//
//  Created by User on 13/12/22.
//

import UIKit

class EnterScreenViewController: UIViewController {

    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyles()
    }

    private func viewStyles(){
        self.createAccountButton.layer.cornerRadius = 25
        self.signInButton.layer.cornerRadius = 25
        self.createAccountButton.layer.borderWidth = 2
        self.signInButton.layer.borderWidth = 2
        self.createAccountButton.layer.borderColor = UIColor.white.cgColor
        self.signInButton.layer.borderColor = UIColor.systemRed.cgColor

    }
    
    
    @IBAction func createButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func signInButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
}


