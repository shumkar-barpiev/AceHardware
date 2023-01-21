//
//  CartViewController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class CartViewController: UIViewController {

    
    @IBOutlet weak var bottomCartView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
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
        self.bottomCartView.roundCorners([.topLeft, .topRight], radius: 30)
                
        self.checkoutButton.layer.cornerRadius = 15
    }
}
