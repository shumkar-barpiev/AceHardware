//
//  ProductCartView.swift
//  AceHardware001
//
//  Created by User on 2/2/23.
//

import Foundation

import UIKit

class ProductCardView: UIView{
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
        layer.cornerRadius = 5
        layer.shadowOpacity = 0.3
    }
}
