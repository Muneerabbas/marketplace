//
//  SellProductView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct SellProductView: View {
    @EnvironmentObject var store: ProductStore
    @EnvironmentObject var auth: AuthViewModel

    @State private var name: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var selectedLocation: String = "Jaipur"
    @State private var selectedCategory = "Electronics"
    @State private var showSuccess: Bool = false
    @State private var isSubmitting = false

    let locations: [String] = [
        "Jaipur", "Srinagar", "Mumbai", "Delhi", "Pune",
        "Bengaluru", "Hyderabad", "Chennai", "Kolkata"
    ]

    let categories = [
        "Electronics",
        "Mobiles",
        "Audio",
        "Gaming",
        "Cameras",
        "Wearables",
        "Accessories"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Product Info") {
                    TextField("Product name", text: $name)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)

                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Description") {
                    TextField("Write something about it...", text: $description, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("Location") {
                    Picker("Location", selection: $selectedLocation) {
                        ForEach(locations, id: \.self) { location in
                            Text(location)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if let error = store.errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }

                Section {
                    Button {
                        Task {
                            await addProduct()
                        }
                    } label: {
                        if isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Add Product")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.semibold)
                        }
                    }
                    .disabled(!isFormValid() || isSubmitting)
                }

                if showSuccess {
                    Text("Product added! Check the Home tab.")
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("Sell Product")
        }
    }

    func isFormValid() -> Bool {
        !name.isEmpty && Double(price) != nil && auth.currentUser != nil
    }

    func addProduct() async {
        guard let user = auth.currentUser,
              let priceValue = Double(price)
        else {
            return
        }

        isSubmitting = true
        showSuccess = false

        let success = await store.addProduct(
            name: name,
            category: selectedCategory,
            price: priceValue,
            description: description,
            location: selectedLocation,
            sellerId: user.id
        )

        isSubmitting = false

        if success {
            name = ""
            price = ""
            description = ""
            showSuccess = true
        }
    }
}

#Preview {
    SellProductView()
        .environmentObject(ProductStore())
        .environmentObject(AuthViewModel())
}
