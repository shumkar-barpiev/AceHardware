//
//  SignInViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit
import CryptoKit

class SignInViewController: UIViewController {
    private var users = [User]()
    private var allEmails = [String]()
    private var allPasswords = [String]()
    private var isExistUser = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        fetchAllUsers()
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
            getEmails()
            getPasswords()
            
            if allEmails.contains(emailTextField.text!) && allPasswords.contains("\(hashPass)"){
                for user in users {
                    if user.email == emailTextField.text! && user.password == "\(hashPass)"{
                        if (user.isAdmin != 0) {
                            print("This user is admin")
                        }else{
                            let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                            controller.modalPresentationStyle = .fullScreen
                            present(controller, animated: false, completion: nil)
                        }
                    }
                }
            }else{
                let alertController = UIAlertController(title: "Warning", message: "There is not like this user or enter your email and password correctly!!!", preferredStyle: .alert)
                let alertTryAction = UIAlertAction(title: "Try again", style: .default) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
                let alertCreateAction = UIAlertAction(title: "Create Account", style: .default) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
                
                alertController.addAction(alertTryAction)
                alertController.addAction(alertCreateAction)
                
                present(alertController, animated: true, completion: nil)
            }
            
        }else{
            let alerController = UIAlertController(title: "Complete all fields!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "ok", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
    
    
    private func fetchAllUsers(){
        getAllUsers { [self] result in
            switch result{
            case .success(let userObjects):
                self.users = userObjects
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/userAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([User].self, from: data)
                    self.users = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
    
    private func getEmails(){
        for user in users {
            allEmails.append(user.email)
        }
        
    }
    
    private func getPasswords(){
        for user in users {
            allPasswords.append(user.password)
        }
    }
    
}
