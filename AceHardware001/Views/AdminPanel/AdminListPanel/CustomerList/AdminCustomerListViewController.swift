//
//  AdminCustomerListViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class AdminCustomerListViewController: UIViewController {
    
    
    @IBOutlet weak var customersListTableView: UITableView!
    
    var users = [User]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchAllUsers()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminListNavViewController") as! AdminListNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    //    MARK: register cells
    func registerCells(){
        customersListTableView.register( UINib(nibName: CustomerListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CustomerListTableViewCell.identifier )
    }
    
//    MARK: fetch all users
    
    private func fetchAllUsers(){
        getAllUsers { [self] result in
            switch result{
            case .success(let userObjects):
                self.users = userObjects
                DispatchQueue.main.async {
                    self.customersListTableView.reloadData()
                }
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
    
}


extension AdminCustomerListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customersListTableView.dequeueReusableCell(withIdentifier: CustomerListTableViewCell.identifier)
         as! CustomerListTableViewCell
        
        cell.setUp(customer: users[indexPath.row ])
        
        return cell
    }    
}
