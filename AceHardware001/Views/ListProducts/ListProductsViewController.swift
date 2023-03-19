//
//  ListProductsViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 19/2/23.
//

import UIKit

class ListProductsViewController: UIViewController {

    @IBOutlet weak var productListTableView: UITableView!
    
    var category = [Category]()
    var user = [User]()
    var products = [Product]()
    var popularProducts = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category[0].categoryName
        registerCells()
        fetchProductsByCategory(category[0].id)
    }
    
    
    func registerCells(){
        productListTableView.register( UINib(nibName: ProductListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductListTableViewCell.identifier )
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
        controller.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    
    
//    MARK: getting products by category
    
    private func fetchProductsByCategory(_ id: Int){
        getProductsByCategory({ [self] result in
            switch result{
            case .success(let productObjects):
                self.products = productObjects
                DispatchQueue.main.async {
                    self.productListTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
            }
        }, id)
        
    }
    
    public func getProductsByCategory(_ completion: @escaping (Result<[Product], Error>) -> Void, _ categoryID: Int){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/getProductByCategoryAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "categoryID": categoryID
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
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


extension ListProductsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productListTableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier)
         as! ProductListTableViewCell
        
        cell.setUp(product: products[indexPath.row ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsNavViewController") as! ProductDetailsNavViewController
        
        let vc = controller.topViewController as! ProductDetailsViewController
        vc.user = self.user
        var arrProduct = [Product]()
        arrProduct.append(products[indexPath.row])
        
        vc.product = arrProduct
        
        var newArr = [Product]()
        for product in popularProducts{
            if product.id == popularProducts[indexPath.row].id{
                continue
            }else{
                newArr.append(product)
            }
        }
        vc.relatedProducts = newArr
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
}
