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
    
    @IBAction func tapLogout(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure?", message: "Would you like to log out from this app.", preferredStyle: .alert)
        let alertYesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! EnterScreenViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
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
    
    
    
    
}
