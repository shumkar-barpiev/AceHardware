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
    
    
    
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewStyle()
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
    
    

}
