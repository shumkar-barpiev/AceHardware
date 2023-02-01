//
//  HomeViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var cartButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let categories: [Category] = [
        .init(id: 1, categoryName: "Home Living", categoryImageName: "imageHome"),
        .init(id: 1, categoryName: "Auto", categoryImageName: "imageCar"),
        .init(id: 1, categoryName: "Cleaning Supplies", categoryImageName: "imageCleaningSupplies"),
        .init(id: 1, categoryName: "Tools", categoryImageName: "imageHomeTools"),
        .init(id: 1, categoryName: "Kitchen", categoryImageName: "imageKitchen"),
        .init(id: 1, categoryName: "Lamps", categoryImageName: "imageLamp"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
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
        
    }
    
    
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.setUp(category: categories[indexPath.row])
        return cell
    }
    
    
}
