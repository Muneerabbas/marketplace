//
//  LoginView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//



import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {

            Spacer()

            // App logo / icon
            Image(systemName: "bag.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)

            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Login to continue shopping")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            // Username field
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                TextField("Username", text: $username)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Password field
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(.gray)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Show error if there is one
            if let error = auth.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            // Login button
            Button {
                Task {
                    await auth.login(username: username, password: password)
                }
            } label: {
                if auth.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Login")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.blue)
            .cornerRadius(10)
            .disabled(auth.isLoading)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
