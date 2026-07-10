//
//  User.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let name: String
    let email: String
    let uploadedProductIds: [String]
    let orders: [Product]
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
        case uploadedProducts
        case orders
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        orders = try container.decodeIfPresent([Product].self, forKey: .orders) ?? []

        if let ids = try? container.decode([String].self, forKey: .uploadedProducts) {
            uploadedProductIds = ids
        } else if let products = try? container.decode([Product].self, forKey: .uploadedProducts) {
            uploadedProductIds = products.map(\.id)
        } else {
            uploadedProductIds = []
        }

        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(uploadedProductIds, forKey: .uploadedProducts)
        try container.encode(orders, forKey: .orders)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
    }
}
