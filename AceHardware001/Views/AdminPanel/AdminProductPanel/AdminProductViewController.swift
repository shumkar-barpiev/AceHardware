//
//  AdminProductViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminProductViewController: UIViewController {
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productImageNameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextView!
    
    
    var categoryNames = [String]()
    
    var categories: [Category] = []
    
    
    var categoryPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryTextField.inputView = categoryPickerView
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        
        fetchAllCategories()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    @IBAction func createButtonAction(_ sender: Any) {
        
        if !(self.productNameTextField.text?.isEmpty ?? true)! && !(self.categoryTextField.text?.isEmpty ?? true)! && !(self.productImageNameTextField.text?.isEmpty ?? true)! && !(self.productDescriptionTextField.text?.isEmpty ?? true)! && !(self.priceTextField.text?.isEmpty ?? true)! {
            
            if let price = Double("\(self.priceTextField.text!)"){
                let didSave = createProduct(self.productNameTextField.text!, self.productImageNameTextField.text!, price, self.productDescriptionTextField.text!)
                
                if didSave{
                    let alertController = UIAlertController(title: .none, message: "Продукт ийгиликтүү түзүлдү.", preferredStyle: .alert)
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
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AdminProductNavViewController") as! AdminProductNavViewController
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: true, completion: nil)
                    }
                    
                    alertController.addAction(alertAction)
                    present(alertController, animated: true, completion: nil)
                }
                
            }else{
                let alerController = UIAlertController(title: "Продукттун баасын туура киргизиңиз!!!", message: "", preferredStyle: .alert)
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
    
    
    
    
    //    MARK: creating new product function
    private func createProduct(_ productName: String, _ productImageName: String,  _ price: Double, _ productDescription: String ) -> Bool{
        var createUserResponse = true
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/productAPI.php" ) else{
            return false
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "productName": productName,
            "description": productDescription,
            "price": price,
            "productImageName": productImageName
            
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
    
    // MARK: fetching all categories
    private func fetchAllCategories(){
        getAllCategories{ [self] result in
            switch result{
            case .success(let categoryObjects):
                self.categories = categoryObjects
                for category in categories {
                    self.categoryNames.append(category.categoryName)
                }
                
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func getAllCategories(completion: @escaping (Result<[Category], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/categoryAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Category].self, from: data)
                    self.categories = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


extension AdminProductViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = categoryNames[row]
    }
}
