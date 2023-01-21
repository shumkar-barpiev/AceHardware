//
//  SuggestionsNavController.swift
//  AceHardware001
//
//  Created by User on 15/12/22.
//

import UIKit

class SuggestionsNavController: UINavigationController {
    
    @IBOutlet weak var suggestionTabbarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
    }
    

    private func viewStyle(){
        self.suggestionTabbarItem.selectedImage = UIImage(systemName: "book.fill")
    }


}
