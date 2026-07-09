//
//  User.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
    let image: String?

    var fullName: String {
        "\(firstName) \(lastName)"
    }
}
