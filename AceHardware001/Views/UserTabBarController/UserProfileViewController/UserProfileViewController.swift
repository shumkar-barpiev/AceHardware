//
//  UserProfileViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class UserProfileViewController: UIViewController {
    var user = [User]()
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var lastActiveDateLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        usernameLabel.text = user[0].userName
        profileImageView.image = UIImage(named: user[0].userImageName)
        emailLabel.text = user[0].email
        phoneNumberLabel.text = user[0].phoneNumber
        lastActiveDateLabel.text = user[0].lastActiveDate
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
    
    
    @IBAction func editAccountButtonAction(_ sender: Any) {
        
        print("Edit account")
        
        print(user)
    }
    
    
}
