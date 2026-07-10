//
//  ProfileView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer()

                // Profile image (loaded from url)
                if let user = auth.currentUser {
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("\(user.orders.count) orders")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 4)
                } else {
                    Text("No user logged in")
                        .foregroundColor(.gray)
                }

                Spacer()

                // Logout button
                Button {
                    auth.logout()
                } label: {
                    Text("Log Out")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.red)
                .cornerRadius(10)
                .padding()
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
