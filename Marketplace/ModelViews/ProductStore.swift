//
//  ProductStore.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI
import Combine

@MainActor
class ProductStore: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let productService = ProductService()

    func fetchProducts() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            products = try await productService.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addProduct(
        name: String,
        category: String,
        price: Double,
        description: String,
        location: String,
        sellerId: String
    ) async -> Bool {
        errorMessage = nil

        do {
            let product = try await productService.createProduct(
                name: name,
                category: category,
                price: price,
                description: description,
                location: location,
                sellerId: sellerId
            )
            products.insert(product, at: 0)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    func purchaseProduct(productId: String, userId: String) async -> User? {
        errorMessage = nil

        do {
            return try await productService.purchaseProduct(userId: userId, productId: productId)
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }
}
