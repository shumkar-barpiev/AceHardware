//
//  AdminPanelViewController.swift
//  AceHardware001
//
//  Created by User on 24/1/23.
//

import UIKit

class AdminPanelViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Category Button Action
    @IBAction func categoryButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminCategoryNavViewController") as! AdminCategoryNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    //    MARK: product button action
    @IBAction func productButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminProductNavViewController") as! AdminProductNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    //    MARK: list button action
    @IBAction func listButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminListNavViewController") as! AdminListNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
        
    }
    
    //    MARK: order button action
    @IBAction func orderButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminOrderNavViewController") as! AdminOrderNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    //    MARK: comment button action
    @IBAction func commentButtonAction(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AdminCommentNavViewController") as! AdminCommentNavViewController
        
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false)
    }
    
    
    //    MARK: tap logout button
    
    @IBAction func tapLogoutAction(_ sender: Any) {
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
    
}
