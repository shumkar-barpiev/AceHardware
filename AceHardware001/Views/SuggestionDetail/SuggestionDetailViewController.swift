//
//  SuggestionDetailViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 19/3/23.
//

import UIKit

class SuggestionDetailViewController: UIViewController {
    
    var user = [User]()
    var category = [Category]()
    var products = [Product]()
    var popularProducts = [Product]()
    
    
    @IBOutlet weak var suggestionProductsCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var suggestionDetailView: UIView!
    
    @IBOutlet weak var suggestionImageView: UIImageView!
    @IBOutlet weak var suggestionName: UILabel!
    @IBOutlet weak var suggestionDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        registerCells()
        fetchProductsByCategory(category[0].id)
        fetchPopularProducts()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    private func viewStyle(){
        self.suggestionDetailView.roundCorners([.topLeft, .topRight], radius: 30)
        self.suggestionName.text = category[0].categoryName
        self.suggestionImageView.image = UIImage(named: "\(category[0].categoryImageName)")
        self.suggestionDescription.text = category[0].categoryDescription
        
    }
    
    private func registerCells(){
        suggestionProductsCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
    }
    
    
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
        controller.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func tapCart(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
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
                    self.suggestionProductsCollectionView.reloadData()
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
    
    
//    MARK: fetching popular products
    
    private func fetchPopularProducts(){
        getPopularProducts{ [self] result in
            switch result{
            case .success(let productObjects):
                self.popularProducts = productObjects
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


extension SuggestionDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        cell.setUp(product: products[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsNavViewController") as! ProductDetailsNavViewController
        
        let vc = controller.topViewController as! ProductDetailsViewController
        vc.user = self.user
        var arrProduct = [Product]()
        arrProduct.append(products[indexPath.row])
        
        vc.product = arrProduct
        
        var newArr = [Product]()
        for product in popularProducts{
            if product.id == products[indexPath.row].id{
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
