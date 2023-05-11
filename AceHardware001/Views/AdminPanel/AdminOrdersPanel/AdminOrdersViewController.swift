//
//  AdminOrdersViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 20/3/23.
//

import UIKit

class AdminOrdersViewController: UIViewController {
    
    var orders = [Order]()
    
    
    @IBOutlet weak var ordersTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchAllOrders()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminNavBarController") as! AdminNavBarController

        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    //    MARK: register cells
        func registerCells(){
            ordersTableView.register( UINib(nibName: OrderListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderListTableViewCell.identifier )
        }
    
    
//    MARK: fetch all orders
    private func fetchAllOrders(){
        getAllOrders{ [self] result in
            switch result{
            case .success(let orderObjects):
                self.orders = orderObjects
                DispatchQueue.main.async {
                    self.ordersTableView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func getAllOrders(completion: @escaping (Result<[Order], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/ordersAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Order].self, from: data)
                    self.orders = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


extension AdminOrdersViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: OrderListTableViewCell.identifier)
         as! OrderListTableViewCell
        
        cell.setUp(order: orders[indexPath.row ])
        
        return cell
    }
    
    
}
