//
//  HomeViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var categories: [Category] = []
    var products: [Product] = [
        .init(id: 1, productName: "Iphone 14", description: "Veri cool Iphone model", price: 1200.0, productImageName: "imageMobilePhones"),
        .init(id: 2, productName: "Sofa", description: "Veri cool Iphone model", price: 170.0, productImageName: "imageHome"),
        .init(id: 3, productName: "Macbook pro 14 M1", description: "Veri cool Iphone model", price: 2300.0, productImageName: "imageLaptops"),
        .init(id: 1, productName: "Iphone 14", description: "Veri cool Iphone model", price: 1200.0, productImageName: "imageMobilePhones"),
        .init(id: 2, productName: "Sofa", description: "Veri cool Iphone model", price: 170.0, productImageName: "imageHome"),
        .init(id: 3, productName: "Macbook pro 14 M1", description: "Veri cool Iphone model", price: 2300.0, productImageName: "imageLaptops"),
        .init(id: 1, productName: "Iphone 14", description: "Veri cool Iphone model", price: 1200.0, productImageName: "imageMobilePhones"),
        .init(id: 2, productName: "Sofa", description: "Veri cool Iphone model", price: 170.0, productImageName: "imageHome"),
        .init(id: 3, productName: "Macbook pro 14 M1", description: "Veri cool Iphone model", price: 2300.0, productImageName: "imageLaptops"),
        .init(id: 1, productName: "Iphone 14", description: "Veri cool Iphone model", price: 1200.0, productImageName: "imageMobilePhones"),
        .init(id: 2, productName: "Sofa", description: "Veri cool Iphone model", price: 170.0, productImageName: "imageHome"),
        .init(id: 3, productName: "Macbook pro 14 M1", description: "Veri cool Iphone model", price: 2300.0, productImageName: "imageLaptops")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        print(products)
        fetchAllCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }

    
    @IBAction func tapLogout(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Would you like to log out from this app.", preferredStyle: .alert)
        let alertYesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! EnterScreenViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
        }
        let alertNoAction = UIAlertAction(title: "No", style: .default) { _ in
            
        }
        
        alertController.addAction(alertYesAction)
        alertController.addAction(alertNoAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapCart(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    private func registerCells(){
        categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        
        productCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
    }
    
    private func fetchAllCategories(){
        getAllCategories{ [self] result in
            switch result{
            case .success(let categoryObjects):
                self.categories = categoryObjects
                DispatchQueue.main.async {
                    categoryCollectionView.reloadData()
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
            case categoryCollectionView:
                return categories.count
            case productCollectionView:
                return products.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        switch collectionView{
            case categoryCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
                cell.setUp(category: categories[indexPath.row])
                return cell
            case productCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
                cell.setUp(product: products[indexPath.row])
                
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    
}
