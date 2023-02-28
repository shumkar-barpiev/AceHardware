//
//  SuggestionsViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class SuggestionsViewController: UIViewController {
    var user = [User]()
    
    @IBOutlet weak var suggestionsView: UIView!
    @IBOutlet weak var suggestionsCollectionView: UICollectionView!
    
    
    var suggestionCategories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        registerCells()
        fetchAllCategories()
    }
    
    private func viewStyle(){
        self.suggestionsView.roundCorners([.topLeft, .topRight], radius: 30)
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
        suggestionsCollectionView.register(UINib(nibName: SuggestionsCollectionViewCell.identifier, bundle: nil ), forCellWithReuseIdentifier: SuggestionsCollectionViewCell.identifier )
    }
    
    
//    fetching categories from backend
    
    private func fetchAllCategories(){
        getAllCategories{ [self] result in
            switch result{
            case .success(let categoryObjects):
                self.suggestionCategories = categoryObjects
                DispatchQueue.main.async {
                    suggestionsCollectionView.reloadData()
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
                    self.suggestionCategories = result
                    completion(.success(result))
                }catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
}


extension SuggestionsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return suggestionCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = suggestionsCollectionView.dequeueReusableCell(withReuseIdentifier: SuggestionsCollectionViewCell.identifier, for: indexPath) as! SuggestionsCollectionViewCell
        
        cell.setUp(category: suggestionCategories[indexPath.row])
        
        return cell
    }
    
    
}
