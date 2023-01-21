//
//  HomeNavigationViewController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class HomeNavigationViewController: UINavigationController {

    @IBOutlet weak var homeTabbarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
    }
    
    private func viewStyle(){
        self.homeTabbarItem.selectedImage = UIImage(systemName: "house.fill")
    }
}
