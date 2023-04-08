//
//  AdminCommentViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminCommentViewController: UIViewController {

    var products = [Product]()
    var user = [User]()
    
    
    
    
    @IBOutlet weak var productTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        fetchAllProducts()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController
        
        let adminPanelController = controller.topViewController as! AdminPanelViewController
        
        adminPanelController.user = self.user

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    //    MARK: register cell
        func registerCells(){
            productTableView.register( UINib(nibName: ProductListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductListTableViewCell.identifier )
        }
    
    
    
//    MARK: fetch all products
    private func fetchAllProducts(){
        getAllProducts{ [self] result in
            switch result{
            case .success(let productObjects):
                self.products = productObjects
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
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



extension AdminCommentViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier)
         as! ProductListTableViewCell
        
        cell.setUp(product: products[indexPath.row ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AdminProductCommentsNavViewController") as! AdminProductCommentsNavViewController
        
        let vc = controller.topViewController as! AdminProductCommentsViewController
        
        var products: [Product] = [products[indexPath.row]]
        
        vc.product = products
        vc.user = self.user
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
        
        
    }
}
