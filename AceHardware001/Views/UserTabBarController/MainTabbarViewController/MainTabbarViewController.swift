//
//  MainTabbarViewController.swift
//  AceHardware001
//
//  Created by User on 14/12/22.
//

import UIKit

class MainTabbarViewController: UITabBarController {
    var user = [User]()
    @IBOutlet weak var mainTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTabbarCorner()
        
        let navVC1  = self.viewControllers![0] as! HomeNavigationViewController
        let homeViewController = navVC1.topViewController as! HomeViewController
        homeViewController.user = self.user
        
        
        let navVC2  = self.viewControllers![1] as! SuggestionsNavController
        let suggestionViewController = navVC2.topViewController as! SuggestionsViewController
        suggestionViewController.user = self.user
        
        
        let navVC3  = self.viewControllers![2] as! WishListNavController
        let wishlistViewController = navVC3.topViewController as! WishListViewController
        wishlistViewController.user = self.user
        
        let navVC4  = self.viewControllers![3] as! UserProfileNavController
        let userProfileViewController = navVC4.topViewController as! UserProfileViewController
        userProfileViewController.user = self.user
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.changingHeightTabbar()
        
    }
    
    func changeTabbarCorner(){
        self.tabBar.layer.masksToBounds = true
        self.tabBar.isTranslucent = true
        self.tabBar.layer.cornerRadius = 30
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    
    func changingHeightTabbar(){
        if UIDevice().userInterfaceIdiom == .phone{
            var tabFrame = tabBar.frame
            tabFrame.size.height = 100
            tabFrame.origin.y = view.frame.size.height - 100
            tabBar.frame = tabFrame
        }
    }

}
