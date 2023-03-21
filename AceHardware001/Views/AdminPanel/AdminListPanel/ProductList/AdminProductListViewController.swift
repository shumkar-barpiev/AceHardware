//
//  AdminProductListViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class AdminProductListViewController: UIViewController {

    @IBOutlet weak var adminProductListTableView: UITableView!
    
    var products = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchAllProducts()
        // Do any additional setup after loading the view.
    }
    

   
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminListNavViewController") as! AdminListNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
//    MARK: register cells
    func registerCells(){
        adminProductListTableView.register( UINib(nibName: ProductListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductListTableViewCell.identifier )
    }
    
    
    
//    MARK: fetch all products
    private func fetchAllProducts(){
        getAllProducts{ [self] result in
            switch result{
            case .success(let productObjects):
                self.products = productObjects
                DispatchQueue.main.async {
                    self.adminProductListTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func getAllProducts(completion: @escaping (Result<[Product], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/productAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Product].self, from: data)
                    self.products = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


extension AdminProductListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = adminProductListTableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier)
         as! ProductListTableViewCell
        
        cell.setUp(product: products[indexPath.row ])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Иш-аракеттер тизмеси.", message: "", preferredStyle: .alert)

        let alertDeleteAction = UIAlertAction(title: "Товарды өчүрүү", style: .default) { _ in
            self.deleteProduct(self.products[indexPath.row].id)
            
            let alertController = UIAlertController(title: "Товар ийгиликтүү өчүрүлдү!!!", message: .none, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Түшүнүктүү", style: .default) { _ in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false, completion: nil)
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        let alertCancelAction = UIAlertAction(title: "Айныдым", style: .cancel) { _ in
            
        }
        
        alertController.addAction(alertDeleteAction)
        alertController.addAction(alertCancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //    MARK:  delete the product by id
    public func deleteProduct(_ productId: Int){
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/productAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "productId": productId
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
                print("something wrong")
            }
        }
        
        task.resume()
    }
    
}
