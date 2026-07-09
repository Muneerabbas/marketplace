//
//  LoginResponse.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct LoginResponse: Codable {

    let accessToken: String
    let refreshToken: String?

    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let image: String?

    var user: User {
        User(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
        
            image: image
        )
    }
}
