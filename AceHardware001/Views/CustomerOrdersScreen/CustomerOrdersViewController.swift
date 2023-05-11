//
//  CustomerOrdersViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import UIKit

class CustomerOrdersViewController: UIViewController {

    var user = [User]()
    var myOrders = [Order]()
    
    @IBOutlet weak var customerOrdersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(user.count > 0){
            fetchCustomerOrders(user[0].id)
        }
        registerCells()
        
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    //    MARK: register cells
        func registerCells(){
            customerOrdersTableView.register( UINib(nibName: OrderListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: OrderListTableViewCell.identifier )
        }
    
    //    MARK: getting customer orders
    
    private func fetchCustomerOrders(_ id: Int){
        getCustomerOrders({ [self] result in
            switch result{
            case .success(let myOrders):
                self.myOrders = myOrders
                
                DispatchQueue.main.async {
                    self.customerOrdersTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                break
            }
        }, id)
        
    }
    
    
    public func getCustomerOrders(_ completion: @escaping (Result<[Order], Error>) -> Void, _ customerId: Int){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerOrdersAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "customerId": customerId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Order].self, from: data)
                    self.myOrders = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    

}


extension CustomerOrdersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerOrdersTableView.dequeueReusableCell(withIdentifier: OrderListTableViewCell.identifier)
         as! OrderListTableViewCell
        
        cell.setUp(order: myOrders[indexPath.row ])
        
        return cell
    }
    
    
}
