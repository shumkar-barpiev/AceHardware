//
//  UserProfileViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
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
        self.profileView.roundCorners([.topLeft, .topRight], radius: 30)
        self.profileImageView.layer.cornerRadius = 52
        self.parentView.bringSubviewToFront(profileImageView)
        
    }
}
