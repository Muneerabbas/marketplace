//
//  AuthService.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

enum APIError: LocalizedError {
    case badURL
    case badResponse
    case serverMessage(String)

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Invalid server URL"
        case .badResponse:
            return "Something went wrong. Please try again."
        case .serverMessage(let message):
            return message
        }
    }
}

class AuthService {

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func login(
        email: String,
        password: String
    ) async throws -> LoginResponse {

        guard let url = URL(string: "\(APIConfig.baseURL)/api/auth/login") else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = LoginRequest(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        if httpResponse.statusCode == 200 {
            return try decoder.decode(LoginResponse.self, from: data)
        }

        throw APIError.serverMessage(parseErrorMessage(from: data))
    }

    func signup(
        name: String,
        email: String,
        password: String
    ) async throws -> LoginResponse {

        guard let url = URL(string: "\(APIConfig.baseURL)/api/auth/signup") else {
            throw APIError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SignupRequest(name: name, email: email, password: password)
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        if (200...299).contains(httpResponse.statusCode) {
            return try decoder.decode(LoginResponse.self, from: data)
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
