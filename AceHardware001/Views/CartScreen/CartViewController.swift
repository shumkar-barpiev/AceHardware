//
//  CartViewController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class CartViewController: UIViewController {
    var user = [User]()
    var userCart = [Cart]()
    var cartProducts = [Product]()
    
    
    @IBOutlet weak var cartTableView: UITableView!
    
    
    @IBOutlet weak var bottomCartView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    @IBOutlet weak var totalSum: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        if user.count > 0{
            fetchCustomerCart(user[0].id)
        }
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "logo1.png")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    
    private func viewStyle(){
        self.bottomCartView.roundCorners([.topLeft, .topRight], radius: 30)
                
        self.checkoutButton.layer.cornerRadius = 15
    }
    
    
    @IBAction func goHome(_ sender: Any) {
       
        let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
        controller.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func sendOrderButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "OrderNavViewController") as! OrderNavViewController
        let orderViewController = controller.topViewController as! OrderViewController
        orderViewController.user = self.user
        orderViewController.cartProducts = self.cartProducts
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    //    MARK: fetching customer cart
        
        private func fetchCustomerCart(_ id: Int){
            getCustomerCart({ [self] result in
                switch result{
                case .success(let cartObjects):
                    
                    if cartObjects.count > 0{
                        fetchCustomerProductsInCart(self.userCart[0].id)
                    }
                    
                case .failure(let error):
                    print(error)
                    break
                }
            }, id)
            
        }
        
        public func getCustomerCart(_ completion: @escaping (Result<[Cart], Error>) -> Void, _ customerId: Int){
            guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerCartAPI.php" ) else{
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
                        let result = try JSONDecoder().decode([Cart].self, from: data)
                        self.userCart = result
                        
                        print("\(self.userCart)")
                        completion(.success(result))
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    
    
    
    //    MARK: getting customer cart products
    
    private func fetchCustomerProductsInCart(_ id: Int){
        getCartProducts({ [self] result in
            switch result{
            case .success(let productObjects):
                self.cartProducts = productObjects
                
                if productObjects.count > 0{
                    DispatchQueue.main.async {
                        var summa = 0.0
                        
                        for product in self.cartProducts {
                            summa += product.price
                        }
                        
                        self.totalSum.text = "\(round(100 * summa) / 100) сом"
                        
                        self.cartTableView.reloadData()
                    }
                }
                
                
            case .failure(let error):
                print(error)
                break
            }
        }, id)
        
    }
    
    public func getCartProducts(_ completion: @escaping (Result<[Product], Error>) -> Void, _ cartId: Int){
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerProductsCartAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cartId": cartId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        //make request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error{
                completion(.failure(error))
            }else if let data = data{
                do{
                    let result = try JSONDecoder().decode([Product].self, from: data)
                    self.cartProducts = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
//    MARK: register cell
    func registerCells(){
        cartTableView.register( UINib(nibName: ProductListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ProductListTableViewCell.identifier )
    }
    
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: ProductListTableViewCell.identifier)
         as! ProductListTableViewCell
        
        cell.setUp(product: cartProducts[indexPath.row ])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(cartProducts[indexPath.row].id)
        print()
        
        let alertController = UIAlertController(title: "Иш-аракеттер тизмеси.", message: "", preferredStyle: .alert)
        
        let alertDeleteAction = UIAlertAction(title: "Корзинадан өчүрүү", style: .default) { _ in
            self.deleteFromCart(self.userCart[0].id, self.cartProducts[indexPath.row].id)
            
            let alertController = UIAlertController(title: "Товар ийгиликтүү өчүрүлдү!!!", message: .none, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Түшүнүктүү", style: .default) { _ in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
                controller.user = self.user
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: false, completion: nil)
            }
            
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        let alertCancelAction = UIAlertAction(title: "Айныдым", style: .cancel) { _ in
            
        }
        
        alertController.addAction(alertDeleteAction)
        alertController.addAction(alertCancelAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    //    MARK:  delete from cart
    public func deleteFromCart(_ cartID: Int, _ productID: Int){
        
        guard let url = URL(string:"http://localhost/BackendAPIphp/api/customerCartAPI.php" ) else{
            return
        }
        
        var request = URLRequest(url: url)
        
        // method body, headers
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: AnyHashable] = [
            "cartId": cartID,
            "productId": productID
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
                print("something wrong")
            }
        }
        
        task.resume()
    }
    
}
