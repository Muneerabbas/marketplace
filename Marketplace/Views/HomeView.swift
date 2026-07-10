//
//  HomeView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var store: ProductStore

    @State var selectedLocation: String = "All"
    @State var searchText = ""

    // Locations to show in the dropdown
    let locations = [
        "All", "Srinagar", "Mumbai", "Delhi", "Pune",
        "Bengaluru", "Hyderabad", "Chennai", "Jaipur", "Kolkata"
    ]

    // Categories shown as boxes. Each has a name and an SF Symbol icon.
    let categories: [(name: String, icon: String)] = [
        ("Mobiles", "iphone"),
        ("Electronics", "laptopcomputer"),
        ("Audio", "headphones"),
        ("Gaming", "gamecontroller.fill"),
        ("Cameras", "camera.fill"),
        ("Wearables", "applewatch")
    ]

    // Filter products by the chosen location and the search text.
    var filteredProducts: [Product] {
        store.products.filter { product in
            let matchesLocation = selectedLocation == "All" || product.location == selectedLocation
            let matchesSearch = searchText.isEmpty || product.name.localizedCaseInsensitiveContains(searchText)
            return matchesLocation && matchesSearch
        }
    }

    var body: some View {
        NavigationStack {
            List {
                // Location dropdown
                Section {
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                        Picker("Location", selection: $selectedLocation) {
                            ForEach(locations, id: \.self) { location in
                                Text(location)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                // Search bar
                Section {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search products...", text: $searchText)
                    }
                }

                // Category boxes
                Section("Categories") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(categories, id: \.name) { category in
                                NavigationLink(destination: CategoryView(category: category.name)) {
                                    VStack(spacing: 8) {
                                        Image(systemName: category.icon)
                                            .font(.title2)
                                            .foregroundColor(.red)
                                        Text(category.name)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                    .frame(width: 80, height: 80)
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(12)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Product list
                Section("Products") {
                    if let error = store.errorMessage, store.products.isEmpty {
                        Text(error)
                            .foregroundColor(.red)
                    }

                    if store.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else if filteredProducts.isEmpty {
                        Text("No products found")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredProducts) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                HStack(spacing: 16) {
                                    Image(systemName: product.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.red)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(product.name)
                                            .font(.headline)
                                        Text(product.location)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Text("$\(product.price, specifier: "%.0f")")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 6)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Marketplace")
            .refreshable {
                await store.fetchProducts()
            }
            .task {
                // Load products the first time the screen appears
                if store.products.isEmpty {
                    await store.fetchProducts()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(ProductStore())
}
