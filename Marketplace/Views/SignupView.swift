//
//  SignupView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var auth: AuthViewModel

    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {

            Spacer()

            // App logo / icon
            Image(systemName: "bag.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(.red)

            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Sign up to start shopping")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.bottom, 20)

            // Name field
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(.gray)
                TextField("Name", text: $name)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)

            // Email field
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                TextField("Email", text: $email)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
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

            // Sign up button
            Button {
                Task {
                    await auth.signup(name: name, email: email, password: password)
                }
            } label: {
                if auth.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding()
                } else {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
            }
            .background(Color.red)
            .cornerRadius(10)
            .disabled(auth.isLoading)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .navigationTitle("Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SignupView()
            .environmentObject(AuthViewModel())
    }
}
