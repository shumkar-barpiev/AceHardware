//
//  UserProfileNavController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class UserProfileNavController: UINavigationController {

    
    @IBOutlet weak var profileTabbarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewStyle()
    }
    
    private func viewStyle(){
        self.profileTabbarItem.selectedImage = UIImage(systemName: "person.fill")
    }

}
