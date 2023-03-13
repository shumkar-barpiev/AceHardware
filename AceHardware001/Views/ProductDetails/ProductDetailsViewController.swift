//
//  ProductDetailsViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 21/2/23.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    var user = [User]()
    var product = [Product]()
    var relatedProducts = [Product]()
    var comments = [Comment]()
    
    
    
    
    @IBOutlet weak var commentBodyTextField: UITextField!
    
    @IBOutlet weak var relatedProductsCollectionView: UICollectionView!
    
    @IBOutlet weak var commentCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        viewStyle()
        fetchProductComments(product[0].id)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    private func viewStyle(){
        self.productDetailView.roundCorners([.topLeft, .topRight], radius: 30)
        
        productImageView.image = UIImage(named: product[0].productImageName)
        productNameLabel.text = product[0].productName
        priceLabel.text = "\(round(100 * product[0].price) / 100) som"
        productDescriptionLabel.text = product[0].description
        
    }
    
//    MARK: Button actions
    
    @IBAction func goBack(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
        controller.user = self.user
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    @IBAction func goToCart(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CartNavController") as! CartNavController
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func likeButtonAction(_ sender: Any) {
        print("like button")
    }
    
    
    @IBAction func commentButtonAction(_ sender: Any) {
        if !(commentBodyTextField.text?.isEmpty ?? true)!{
            
            let customerID = user[0].id
            let productID = product[0].id
            let commentBody = commentBodyTextField.text!
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let today = dateFormatter.string(from: date)
            
            let result = leaveComment(customerID, productID, commentBody, today)
            
            if result{
                let alertController = UIAlertController(title: "", message: "Комментарийиңиз ийгиликтүү сакталды.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .default) { _ in
                    let navController = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsNavViewController") as! ProductDetailsNavViewController
                    
                    let vc = navController.topViewController as! ProductDetailsViewController
                    vc.user = self.user
                    vc.relatedProducts = self.relatedProducts
                    vc.product = self.product
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: false, completion: nil)
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
                
            }else{
                let alertController = UIAlertController(title: "Эскертүү!!!", message: "Кандайдыр бир катачылык кетти.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .default) { _ in
                    
                }
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
    
        }else{
            let alertController = UIAlertController(title: "Эскертүү!!!", message: "Комментарий талаасына маани киргизиңиз.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Макул", style: .default) { _ in
                
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
//    MARK: implementing leaving comment event
    public func leaveComment(_ customerID: Int, _ productId: Int, _ commentBody: String, _ commentCreatedDate: String) -> Bool{
        var returnVal = true
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/leaveComment.php" ) else{
            return false
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "customerID": customerID,
            "productID": productId,
            "commentBody": commentBody,
            "dateOfComment": commentCreatedDate
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else{
                return
            }
            // Convert HTTP Response Data to a String
            if let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }else{
                returnVal = false
            }
        }
        
        task.resume()
        
        return returnVal
    }
    
    
//    MARK: register cell
    
    private func registerCells(){
        relatedProductsCollectionView.register(UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        commentCollectionView.register(UINib(nibName: CommentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        
    }
    
    
    
    private func fetchProductComments(_ productID: Int){
        getProductComments({ [self] result in
            switch result{
            case .success(let commentObjects):
                self.comments = commentObjects
                DispatchQueue.main.async {
                    commentCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                break
            }
        }, productID)
        
    }
    
    public func getProductComments(_ completion: @escaping (Result<[Comment], Error>) -> Void, _ productID: Int){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/getProductCommentsCustomer.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "productId": productID
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Comment].self, from: data)
                    self.comments = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


extension ProductDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
            case relatedProductsCollectionView:
                return relatedProducts.count
            case commentCollectionView:
                return comments.count
            default:
                return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
            case relatedProductsCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
                cell.setUp(product: relatedProducts[indexPath.row])
                
                return cell
            case commentCollectionView:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
            
                cell.setUp(comment: comments[indexPath.row])
                
                return cell
            default:
                return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView{
            case relatedProductsCollectionView:
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsNavViewController") as! ProductDetailsNavViewController
                
                let vc = controller.topViewController as! ProductDetailsViewController
                vc.user = self.user
                relatedProducts.append(self.product[0])
                
                var arrProduct = [Product]()
                arrProduct.append(relatedProducts[indexPath.row])
                
                vc.product = arrProduct
                
                var newArr = [Product]()
                for product in relatedProducts{
                    if product.id == relatedProducts[indexPath.row].id{
                        continue
                    }else{
                        newArr.append(product)
                    }
                }
                vc.relatedProducts = newArr
            
                controller.modalPresentationStyle = .fullScreen
                present(controller, animated: false, completion: nil)
                
            default:
                return
        }
    }
    
    
}
