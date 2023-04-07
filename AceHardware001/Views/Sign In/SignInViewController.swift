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
    private var carts = [Cart]()
    private var allEmails = [String]()
    private var allPasswords = [String]()
    private var allCustomerId = [Int]()
    private var isExistUser = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        fetchAllUsers()
        
        fetchAllCarts()
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
        let controller = storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! EnterScreenViewController
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func signInButtonAction(_ sender: Any) {
        if !(emailTextField.text?.isEmpty ?? true)! && !(passwordTextField.text?.isEmpty ?? true)! {
            let tempPassword = passwordTextField.text!
            let hashPass = SHA512.hash(data: Data(tempPassword.utf8))
            getEmails()
            getPasswords()
            getCustomerId()
            
            if allEmails.contains(emailTextField.text!) && allPasswords.contains("\(hashPass)"){
                for user in users {
                    if user.email == emailTextField.text! && user.password == "\(hashPass)"{
                        if (user.isAdmin != 0) {
                            let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController
                            
                            let adminController  = controller.topViewController as! AdminPanelViewController
                            adminController.user.append(user)
                            
                            controller.modalPresentationStyle = .fullScreen
                            present(controller, animated: false, completion: nil)
                        }else{
                            
                            if !allCustomerId.contains(user.id){
                                let cartName = "\(user.userName) Cart"
                                createCartForCustomer(cartName, user.id)
                            }
                            
                            let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                            controller.modalPresentationStyle = .fullScreen
                            controller.user.append(user)
                            present(controller, animated: false, completion: nil)
                        }
                    }
                }
            }else{
                let alertController = UIAlertController(title: "Эскертүү!!!", message: "Мындай колдонуучу жок же электрондук адрес жана сырсөздү туура киргизиңиз.", preferredStyle: .alert)
                let alertTryAction = UIAlertAction(title: "Кайра сынап көрүү", style: .default) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
                let alertCreateAction = UIAlertAction(title: "Аккаунт түзүү", style: .default) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountViewController") as! CreateAccountViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false, completion: nil)
                }
                
                alertController.addAction(alertTryAction)
                alertController.addAction(alertCreateAction)
                
                present(alertController, animated: true, completion: nil)
            }
            
        }else{
            let alerController = UIAlertController(title: "Бардык талааларды толтуруңуз!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
    
    
    //    MARK: fetch all users
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
    
    //    MARK: fetch all carts of customer
    
    private func fetchAllCarts(){
        getAllCarts { [self] result in
            switch result{
            case .success(let cartObjects):
                self.carts = cartObjects
                
                print(self.carts)
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func getAllCarts(completion: @escaping (Result<[Cart], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerCartAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Cart].self, from: data)
                    self.carts = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
    
    //    MARK: create cart for customer
    
    public func createCartForCustomer(_ cartName: String, _ customerId: Int){
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/createCustomerCartAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cartName": cartName,
            "customerId": customerId
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
                print("Something wrong")
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
    
    private func getCustomerId(){
        for cart in carts {
            allCustomerId.append(cart.customerId)
        }
    }
}
