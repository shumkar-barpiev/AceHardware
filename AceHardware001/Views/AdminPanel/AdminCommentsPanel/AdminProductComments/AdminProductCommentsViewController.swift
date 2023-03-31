//
//  AdminProductCommentsViewController.swift
//  AceHardware001
//
//  Created by Shumkar on 28/3/23.
//

import UIKit

class AdminProductCommentsViewController: UIViewController {
    
    var user = [User]()
    var product = [Product]()
    var comments = [Comment]()
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    @IBOutlet weak var commentsCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(product[0].productName)"
        registerCells()
        fetchProductComments(product[0].id)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func goBackAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminCommentNavViewController") as! AdminCommentNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    @IBAction func commentButtonAction(_ sender: Any) {
        if !(commentTextField.text?.isEmpty ?? true)!{
            
            let customerID = user[0].id
            let productID = product[0].id
            let commentBody = commentTextField.text!
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let today = dateFormatter.string(from: date)

            let result = leaveComment(customerID, productID, commentBody, today)
            
            if result {
                let alertController = UIAlertController(title: "", message: "Комментарийиңиз ийгиликтүү сакталды.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Макул", style: .default) { _ in
                    let navController = self.storyboard?.instantiateViewController(withIdentifier: "AdminCommentNavViewController") as! AdminCommentNavViewController
                    
                    let vc = navController.topViewController as! AdminCommentViewController
                    vc.user = self.user
                    
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
        commentsCollectionView.register(UINib(nibName: CommentCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        
    }
    
    
    //    MARK: fetch product comments
    private func fetchProductComments(_ productID: Int){
        getProductComments({ [self] result in
            switch result{
            case .success(let commentObjects):
                self.comments = commentObjects
                DispatchQueue.main.async {
                    self.commentsCollectionView.reloadData()
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



extension AdminProductCommentsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView{
        case commentsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
            
            cell.setUp(comment: comments[indexPath.row])
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
        
    }
}
