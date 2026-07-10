//
//  AuthViewModel.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//
import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {

    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService = AuthService()

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    var isLoggedIn: Bool {
        currentUser != nil
    }

    init() {
        checkLoginStatus()
    }

    func login(
        email: String,
        password: String
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await authService.login(
                email: email,
                password: password
            )

            saveSession(token: response.token, user: response.user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signup(
        name: String,
        email: String,
        password: String
    ) async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let response = try await authService.signup(
                name: name,
                email: email,
                password: password
            )

            saveSession(token: response.token, user: response.user)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateCurrentUser(_ user: User) {
        currentUser = user
        persistUser(user)
    }

    func logout() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        currentUser = nil
    }

    private func saveSession(token: String, user: User) {
        currentUser = user
        UserDefaults.standard.set(token, forKey: "accessToken")
        persistUser(user)
    }

    private func persistUser(_ user: User) {
        guard let data = try? encoder.encode(user) else { return }
        UserDefaults.standard.set(data, forKey: "currentUser")
    }

    private func checkLoginStatus() {
        guard UserDefaults.standard.string(forKey: "accessToken") != nil,
              let data = UserDefaults.standard.data(forKey: "currentUser")
        else {
            return
        }

        do {
            currentUser = try decoder.decode(User.self, from: data)
        } catch {
            // Clear stale session data if the saved user can't be read
            UserDefaults.standard.removeObject(forKey: "accessToken")
            UserDefaults.standard.removeObject(forKey: "currentUser")
        }
    }
}
