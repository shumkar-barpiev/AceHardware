//
//  HomeViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class HomeViewController: UIViewController {
    var user = [User]()
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var categories: [Category] = []
    var popularProducts: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        fetchAllCategories()
        fetchPopularProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }

    
    @IBAction func tapLogout(_ sender: Any) {
        let alertController = UIAlertController(title: "Чын элеби.", message: "Тиркемеден чыгууну каалайсызбы?", preferredStyle: .alert)
        let alertYesAction = UIAlertAction(title: "Ооба", style: .default) { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! EnterScreenViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
        let alertNoAction = UIAlertAction(title: "Жок", style: .default) { _ in
            
        }
        
        alertController.addAction(alertYesAction)
        alertController.addAction(alertNoAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func tapCart(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
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
                    self.categoryCollectionView.reloadData()
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
    
    
    private func fetchPopularProducts(){
        getPopularProducts{ [self] result in
            switch result{
            case .success(let productObjects):
                self.popularProducts = productObjects
                DispatchQueue.main.async {
                    self.productCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    public func getPopularProducts(completion: @escaping (Result<[Product], Error>) -> Void){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/popularProductsAPI.php" ) else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Product].self, from: data)
                    self.popularProducts = result
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
                return popularProducts.count
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
                cell.setUp(product: popularProducts[indexPath.row])
                
                return cell
            default:
                return UICollectionViewCell()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
//            print(categories[indexPath.row]," cliced!")
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ListProductsNavViewController") as! ListProductsNavViewController
            
            let vc = controller.topViewController as! ListProductsViewController
            vc.user = self.user
            vc.popularProducts = self.popularProducts
            
            var arrCategory = [Category]()
            
            arrCategory.append(categories[indexPath.row])
            
            vc.category = arrCategory
            
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
            
            
        }else if collectionView == productCollectionView{
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsNavViewController") as! ProductDetailsNavViewController
            
            let vc = controller.topViewController as! ProductDetailsViewController
            vc.user = self.user
            
            var newArr = [Product]()
            for product in popularProducts{
                if product.id == popularProducts[indexPath.row].id{
                    continue
                }else{
                    newArr.append(product)
                }
            }
            vc.relatedProducts = newArr
            
            
            var arrProduct = [Product]()
            arrProduct.append(popularProducts[indexPath.row])
            
            vc.product = arrProduct
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: false, completion: nil)
            
        }
    }
    
}
