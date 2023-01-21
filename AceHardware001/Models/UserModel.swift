//
//  UserModel.swift
//  AceHardware001
//
//  Created by User on 21/1/23.
//

import Foundation

struct User: Codable{
    let id: Int
    let userName: String
    let email: String
    let password: String
    let isAdmin: Int
    let lastActiveDate: String
    let phoneNumber: String
}
