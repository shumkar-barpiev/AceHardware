//
//  CreateAccountViewController.swift
//  AceHardware001
//
//  Created by User on 13/12/22.
//

import UIKit
import CryptoKit

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

//    MARK: goback button action
    @IBAction func goBackButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! UIViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
//    MARK: create button action
    @IBAction func createAccountButtonAction(_ sender: Any) {
        if !(usernameTextField.text?.isEmpty ?? true)! && !(emailTextField.text?.isEmpty ?? true)! && !(passwordTextField.text?.isEmpty ?? true)! && !(phoneNumberTextField.text?.isEmpty ?? true)!{
            if passwordTextField.text!.count >= 8{
                let emailString = emailTextField.text!
                let range = NSRange(location: 0, length: emailString.utf16.count)
                let regex = try! NSRegularExpression(pattern: "[a-z0-9]@[a-z].[a-z]")
                
                if regex.firstMatch(in: emailString, options: [], range: range) != nil {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd.MM.yyyy"
                    let today = dateFormatter.string(from: date)
                    let password = passwordTextField.text!
                    
                    let didSave = createUser(usernameTextField.text!,
                                             emailTextField.text!,
                                             "\(SHA512.hash(data: Data(password.utf8)))",
                                             today,
                                             phoneNumberTextField.text!)
                    
                    if didSave{
                        let alertController = UIAlertController(title: "Congratulations, \(usernameTextField.text!)!!!", message: "Your account created succesfully.", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "ok", style: .cancel) { _ in
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! UIViewController
                            controller.modalPresentationStyle = .fullScreen
                            self.present(controller, animated: true, completion: nil)
                        }
                        alertController.addAction(alertAction)
                        present(alertController, animated: true, completion: nil)
                    }else{
                        let alertController = UIAlertController(title: "Warning!!!", message: "Unfortunately, something wrong...", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Try again", style: .cancel) { _ in
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! UIViewController
                            controller.modalPresentationStyle = .fullScreen
                            self.present(controller, animated: true, completion: nil)
                        }
                        
                        alertController.addAction(alertAction)
                        present(alertController, animated: true, completion: nil)
                    }
                }else{
                    let alerController = UIAlertController(title: "Invalid email address!!!", message: "Please, enter your email address correctly.", preferredStyle: .alert)
                    let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
                    alerController.addAction(alerAction)
                    present(alerController, animated: true, completion: nil)
                }
            }else{
                let alerController = UIAlertController(title: "Simple password!!!", message: "Your password must be at least 8 characters.", preferredStyle: .alert)
                let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
                alerController.addAction(alerAction)
                present(alerController, animated: true, completion: nil)
            }
        }else{
            let alerController = UIAlertController(title: "Complete all fields!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
//    MARK: sign in button action
    @IBAction func signInButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! UIViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
 
//    MARK: creating new user function
    private func createUser(_ username: String, _ email: String,_ password: String, _ lastActiveDate: String, _ phoneNumber: String ) -> Bool{
        var createUserResponse = true
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/userAPI.php" ) else{
            return false
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "userName": username,
            "email": email,
            "password": password,
            "isAdmin": 0,
            "lastActiveDate": lastActiveDate,
            "phoneNumber": phoneNumber
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            // Convert HTTP Response Data to a String
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }else{
                createUserResponse = false
            }
        }
        task.resume()
        
        return createUserResponse
    }
}
