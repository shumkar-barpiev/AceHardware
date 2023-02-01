//
//  SwitchViewController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class SwitchViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var didLogout = true
    private var sessions = [Session]().self
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(sessions)
        if !sessions.isEmpty{
            didLogout = false
        }
        
        
        if didLogout{
            let controller = storyboard?.instantiateViewController(withIdentifier: "EnterScreenViewController") as! EnterScreenViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
            
        }else{
            let controller = storyboard?.instantiateViewController(withIdentifier: "MainTabbarViewController") as! MainTabbarViewController
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: false, completion: nil)
        }
    }
    
    //    MARK: Get Sessions
    func getSessions(){
        do{
            sessions = try context.fetch(Session.fetchRequest())
        }catch{
            //error
        }
    }
    
}
