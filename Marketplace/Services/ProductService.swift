//
//  ProductService.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

struct CreateProductRequest: Codable {
    let name: String
    let category: String
    let price: Double
    let description: String
    let location: String
    let icon: String
    let seller: String
}

struct PurchaseRequest: Codable {
    let productId: String
}

class ProductService {

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetchProducts(category: String? = nil, location: String? = nil) async throws -> [Product] {
        var components = URLComponents(string: "\(APIConfig.baseURL)/api/products")
        var queryItems: [URLQueryItem] = []

        if let category, !category.isEmpty {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }

        if let location, !location.isEmpty {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }

        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }

        guard let url = components?.url else {
            throw APIError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw APIError.badResponse
        }

        return try decoder.decode([Product].self, from: data)
    }

    func createProduct(
        name: String,
        category: String,
        price: Double,
        description: String,
        location: String,
        sellerId: String
    ) async throws -> Product {

        guard let url = URL(string: "\(APIConfig.baseURL)/api/products") else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = CreateProductRequest(
            name: name,
            category: category,
            price: price,
            description: description,
            location: location,
            icon: "shippingbox.fill",
            seller: sellerId
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(Product.self, from: data)
        }

        throw APIError.serverMessage(parseErrorMessage(from: data))
    }

    func purchaseProduct(userId: String, productId: String) async throws -> User {
        guard let url = URL(string: "\(APIConfig.baseURL)/api/users/\(userId)/orders") else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = PurchaseRequest(productId: productId)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(User.self, from: data)
        }

        throw APIError.serverMessage(parseErrorMessage(from: data))
    }

    private func parseErrorMessage(from data: Data) -> String {
        struct ErrorResponse: Decodable {
            let error: String
        }

        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return errorResponse.error
        }

        return "Something went wrong. Please try again."
    }
}
