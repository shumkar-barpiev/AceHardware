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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
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
        let cartViewController = controller.topViewController as! CartViewController
        cartViewController.user = self.user
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
}
