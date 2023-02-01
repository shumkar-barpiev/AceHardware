//
//  CartView.swift
//  AceHardware001
//
//  Created by User on 31/1/23.
//

import UIKit

class CardView: UIView{
    override init(frame: CGRect){
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    private func initialSetup(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 25
        layer.shadowOpacity = 0.5
    }
}
