//
//  ProductDetailView.swift
//  AceHardware001
//
//  Created by Shumkar on 21/2/23.
//

import Foundation

import UIKit

class ProductDetailView: UIView{
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
        layer.shadowOffset = CGSize(width: 5, height: 9)
        layer.shadowOpacity = 1
    }
}
