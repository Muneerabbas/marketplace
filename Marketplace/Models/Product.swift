//
//  Product.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct Product: Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let price: Double
    let icon: String
    let description: String
    let location: String

    // The backend calls the id field "_id", so we map it to "id" here.
    // Any extra fields the API sends (seller, createdAt...) are just ignored.
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case category
        case price
        case icon
        case description
        case location
    }

    static let sampleProducts: [Product] = [
        Product(
            id: "1",
            name: "iPhone 15 Pro",
            category: "Mobiles",
            price: 89999,
            icon: "iphone",
            description: "128GB Natural Titanium. Excellent condition with original box.",
            location: "Srinagar"
        ),
        Product(
            id: "2",
            name: "MacBook Air M2",
            category: "Electronics",
            price: 74999,
            icon: "laptopcomputer",
            description: "13-inch, 8GB RAM, 256GB SSD. Barely used.",
            location: "Pune"
        ),
        Product(
            id: "3",
            name: "AirPods Pro (2nd Gen)",
            category: "Audio",
            price: 14999,
            icon: "airpodspro",
            description: "Active Noise Cancellation with MagSafe charging case.",
            location: "Mumbai"
        ),
        Product(
            id: "4",
            name: "Apple Watch Series 9",
            category: "Wearables",
            price: 29999,
            icon: "applewatch",
            description: "45mm GPS model in mint condition.",
            location: "Delhi"
        ),
        Product(
            id: "5",
            name: "iPad Air M2",
            category: "Tablets",
            price: 55999,
            icon: "ipad",
            description: "11-inch Wi-Fi model with Apple Pencil support.",
            location: "Bengaluru"
        ),
        Product(
            id: "6",
            name: "Mechanical Keyboard",
            category: "Accessories",
            price: 4999,
            icon: "keyboard",
            description: "RGB backlit mechanical keyboard with Blue switches.",
            location: "Hyderabad"
        ),
        Product(
            id: "7",
            name: "Sony WH-1000XM5",
            category: "Audio",
            price: 21999,
            icon: "headphones",
            description: "Industry-leading noise cancellation headphones.",
            location: "Chennai"
        ),
        Product(
            id: "8",
            name: "Gaming Monitor 27\"",
            category: "Gaming",
            price: 17999,
            icon: "display",
            description: "144Hz QHD IPS gaming monitor with HDR support.",
            location: "Ahmedabad"
        ),
        Product(
            id: "9",
            name: "PlayStation 5",
            category: "Gaming",
            price: 44999,
            icon: "gamecontroller.fill",
            description: "PS5 Disc Edition with one controller.",
            location: "Kolkata"
        ),
        Product(
            id: "10",
            name: "Canon EOS R50",
            category: "Cameras",
            price: 62999,
            icon: "camera.fill",
            description: "Mirrorless camera with 18-45mm kit lens.",
            location: "Jaipur"
        )
    ]
}
