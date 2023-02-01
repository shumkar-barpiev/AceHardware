//
//  ProductModel.swift
//  AceHardware001
//
//  Created by User on 1/2/23.
//

import Foundation

struct Product: Codable{
    let id: Int
    let productName: String
    let description: String
    let price: Double
    let productImageName: String
}
