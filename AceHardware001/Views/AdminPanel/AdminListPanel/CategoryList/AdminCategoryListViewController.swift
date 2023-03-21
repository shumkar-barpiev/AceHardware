//
//  AdminCategoryListViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 21/3/23.
//

import UIKit

class AdminCategoryListViewController: UIViewController {
    
    
    @IBOutlet weak var categoryListTableView: UITableView!
    
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        fetchAllCategories()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminListNavViewController") as! AdminListNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    //    MARK: register cells
    func registerCells(){
        categoryListTableView.register( UINib(nibName: CategoryListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CategoryListTableViewCell.identifier )
    }
    
    
    //    MARK: fetch all categories
    
    private func fetchAllCategories(){
        getAllCategories{ [self] result in
            switch result{
            case .success(let categoryObjects):
                self.categories = categoryObjects
                DispatchQueue.main.async {
                    self.categoryListTableView.reloadData()
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



extension AdminCategoryListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryListTableView.dequeueReusableCell(withIdentifier: CategoryListTableViewCell.identifier)
        as! CategoryListTableViewCell
        
        cell.setUp(category: categories[indexPath.row ])
        
        return cell
    }
    
    
    
}
