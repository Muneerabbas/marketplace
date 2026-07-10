//
//  SignupRequest.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct SignupRequest: Codable {
    let name: String
    let email: String
    let password: String
}
