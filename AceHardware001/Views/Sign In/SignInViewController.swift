//
//  SignInViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit
import CryptoKit

class SignInViewController: UIViewController {
    private var user = [User]()
    private var isExistUser = false
    
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
            let tempPassword = passwordTextField.text!
            let hashPass = SHA512.hash(data: Data(tempPassword.utf8))
            fetchUser(emailTextField.text!, "\(hashPass)")
            
            if self.user.count == 1{
                let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: false, completion: nil)
            }else{
                print("Kata")
            }
        }else{
            let alerController = UIAlertController(title: "Complete all fields!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
    
    private func fetchUser(_ e: String, _ p: String){
            getUser(e, p) { [self] result in
                switch result{
                case .success(let userObject):
                    self.user = userObject
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    
        
    public func getUser(_ email: String, _ password: String, completion: @escaping (Result<[User], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/getOneUserAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([User].self, from: data)
                    self.user = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
