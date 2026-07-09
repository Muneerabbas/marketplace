//
//  MarketplaceApp.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

@main
struct MarketplaceApp: App {

    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var productStore = ProductStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(productStore)
        }
    }
}
