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
        
        if !(userNameTextField.text?.isEmpty ?? true)! && !(emailTextField.text?.isEmpty ?? true)! && !(phoneNumberTextField.text?.isEmpty ?? true)!{
            let emailString = emailTextField.text!
            let range = NSRange(location: 0, length: emailString.utf16.count)
            let regex = try! NSRegularExpression(pattern: "[a-z0-9A-Z]@[a-z].[a-z]")
            
            if regex.firstMatch(in: emailString, options: [], range: range) != nil {
                if(updateUser(user[0].id, userNameTextField.text!, emailString, user[0].password, phoneNumberTextField.text!)){
                    let alerController = UIAlertController(title: "Куттуктайбыз!!!", message: "Маалыматтарыңыз ийгиликтүү жаңыртылды.", preferredStyle: .alert)
                    let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                        controller.user = self.user
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false, completion: nil)
                    }
                    alerController.addAction(alerAction)
                    present(alerController, animated: true, completion: nil)
                }
            }else{
                let alerController = UIAlertController(title: "Туура эмес электрондук адрес!!!", message: "Сураныч, электрондук дарегиңизди туура киргизиңиз.", preferredStyle: .alert)
                let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
                alerController.addAction(alerAction)
                present(alerController, animated: true, completion: nil)
            }
        }else{
            let alerController = UIAlertController(title: "Бардык талааларды толтуруңуз!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    
    }
    
    
    
//    update user
    public func updateUser( _ userId: Int, _ userName: String, _ email: String, _ password: String, _ phoneNumber: String) -> Bool{
        var response = true
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/userUpdateAPI.php" ) else{
            return false
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "userId": userId,
            "userName": userName,
            "email": email,
            "password": password,
            "phoneNumber": phoneNumber
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                print(error)
                response = false
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([User].self, from: data)
                    self.user = result
                    print(result)
                }catch{
                    print(error)
                    response = false
                }
            }
        }
        task.resume()
        
        return response
    }
    
}


