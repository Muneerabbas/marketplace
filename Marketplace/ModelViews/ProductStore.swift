//
//  ProductStore.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI
import Combine

// Holds all the products so the whole app can share the same list.
// When we add a product here the Home screen updates automatically.
class ProductStore: ObservableObject {

    @Published var products: [Product] = Product.sampleProducts

    func addProduct(name: String, category: String, price: Double, description: String, location: String) {

        // Make a new id (one bigger than the current biggest id)
        let newId = (products.map { $0.id }.max() ?? 0) + 1

        let newProduct = Product(
            id: newId,
            name: name,
            category: category,
            price: price,
            icon: "shippingbox.fill",   // default icon for user added items
            description: description,
            location: location,

        )

        products.append(newProduct)
    }
}
