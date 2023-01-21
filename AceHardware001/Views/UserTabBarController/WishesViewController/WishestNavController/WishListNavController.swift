//
//  WishesNavController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class WishListNavController: UINavigationController {

    @IBOutlet weak var wishesTabbarItem: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
    }
    

    private func viewStyle(){
        self.wishesTabbarItem.selectedImage = UIImage(systemName: "heart.fill")
    }

}
