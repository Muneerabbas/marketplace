//
//  LoginResponse.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct LoginResponse: Codable {
    let token: String
    var user: User
}

