//
//  OrderModel.swift
//  AceHardware001
//
//  Created by Shumkar on 11/5/23.
//

import Foundation

struct Order: Codable{
    let orderId: Int
    let orderName: String
    let orderDate: String
    let orderDescription: String
    let customerId: Int
    let customerName: String
    let address: String
    let phoneNumber: String
    let totalSum: String
    let orderStatus: String
}
