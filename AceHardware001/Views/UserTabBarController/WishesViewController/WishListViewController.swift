//
//  WishestViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class WishListViewController: UIViewController {
    
    @IBOutlet weak var likedProductsCollectionView: UICollectionView!
    
    @IBOutlet weak var wishListView: UIView!
    var user = [User]()
    
    var likedProducts: [Product] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        registerCells()
        fetchLikedProducts(user[0].id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    
    private func viewStyle(){
        self.wishListView.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
//    MARK: register cells
    
    private func registerCells(){
        likedProductsCollectionView.register(UINib(nibName: LikedProductsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: LikedProductsCollectionViewCell.identifier)
        
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
    
    
    //    MARK: getting liked products
    
    private func fetchLikedProducts(_ id: Int){
        getLikedProducts({ [self] result in
            switch result{
            case .success(let productObjects):
                self.likedProducts = productObjects
                DispatchQueue.main.async {
                    self.likedProductsCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                break
            }
        }, id)
        
    }
    
    public func getLikedProducts(_ completion: @escaping (Result<[Product], Error>) -> Void, _ customerId: Int){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/likedProductsAPI.php" ) else{
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
                    let result = try JSONDecoder().decode([Product].self, from: data)
                    self.likedProducts = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    
}


extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedProductsCollectionViewCell.identifier, for: indexPath) as! LikedProductsCollectionViewCell
        cell.setUp(product: likedProducts[indexPath.row])
        
        return cell
    }
    
    
}
