//
//  AuthService.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import Foundation

class AuthService {

    func login(
        username: String,
        password: String
    ) async throws -> LoginResponse {

        guard let url = URL(
            string: "https://dummyjson.com/auth/login"
        ) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        let body = LoginRequest(
            username: username,
            password: password
        )

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(
            LoginResponse.self,
            from: data
        )
    }
}
