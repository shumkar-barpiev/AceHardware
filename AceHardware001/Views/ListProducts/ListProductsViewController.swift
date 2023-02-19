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
    
    var products: [Product] = [
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile"),
        .init(id: 1, productName: "hello", description: "hello", price: 12.02, productImageName: "myprofile")
        
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category[0].categoryName
        registerCells()
        
        
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
}
