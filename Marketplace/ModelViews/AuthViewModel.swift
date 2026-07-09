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

    var isLoggedIn: Bool {
        currentUser != nil
    }

    init() {
        checkLoginStatus()
    }

    func login(
        username: String,
        password: String
    ) async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let response = try await authService.login(
                username: username,
                password: password
            )

            currentUser = response.user

            UserDefaults.standard.set(
                response.accessToken,
                forKey: "accessToken"
            )

        } catch {

            errorMessage = error.localizedDescription

        }
    }

    func logout() {

        UserDefaults.standard.removeObject(
            forKey: "accessToken"
        )

        currentUser = nil

    }

    private func checkLoginStatus() {

        if UserDefaults.standard.string(
            forKey: "accessToken"
        ) != nil {

            // For demo purposes
            currentUser = User(
                   id: 1,
                   firstName: "Emily",
                   lastName: "Johnson",
                   email: "emily.johnson@x.dummyjson.com",
                   image: "https://dummyjson.com/icon/emilys/128"
            )

        }

    }
}
