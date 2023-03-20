//
//  AdminCategoryViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminCategoryViewController: UIViewController {
    
    @IBOutlet weak var categoryNameTextField: UITextField!
    @IBOutlet weak var categoryImageNameTextField: UITextField!
    @IBOutlet weak var categoryDescriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        if !(self.categoryNameTextField.text?.isEmpty ?? true)! && !(self.categoryImageNameTextField.text?.isEmpty ?? true)! && !(self.categoryDescriptionTextField.text?.isEmpty ?? true)! {
            
            let didSave = createCategory(self.categoryNameTextField.text!, self.categoryImageNameTextField.text!, categoryDescriptionTextField.text!)
            
            
            if didSave{
                let alertController = UIAlertController(title: .none, message: "\(self.categoryNameTextField.text!) категориясы ийгиликтүү түзүлдү.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .cancel) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Эскертүү!!!", message: "Тилекке каршы, катачылык кетти...", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Кайра сынап көрүү", style: .cancel) { _ in
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AdminCategoryNavViewController") as! AdminCategoryNavViewController
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: true, completion: nil)
                }
                
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        else{
            let alerController = UIAlertController(title: "Бардык талааларды толтуруңуз!!!", message: "", preferredStyle: .alert)
            let alerAction = UIAlertAction(title: "Макул", style: .cancel) { _ in }
            alerController.addAction(alerAction)
            present(alerController, animated: true, completion: nil)
        }
    }
    
    
    
    
    //    MARK: creating new category function
    private func createCategory(_ categoryName: String, _ categoryImageName: String, _ categoryDescription: String ) -> Bool{
        var createUserResponse = true
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/categoryAPI.php" ) else{
            return false
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "categoryName": categoryName,
            "categoryImageName": categoryImageName,
            "categoryDescription": categoryDescription
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
