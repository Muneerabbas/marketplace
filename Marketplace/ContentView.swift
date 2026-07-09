//
//  ContentView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var auth: AuthViewModel

    var body: some View {

        if auth.isLoggedIn {
            // Show tabs when logged in
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                SellProductView()
                    .tabItem {
                        Label("Sell", systemImage: "plus.circle.fill")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        } else {
            LoginView()
        }

    }
}
#Preview {
    ContentView()
}
