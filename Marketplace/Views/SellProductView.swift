//
//  SellProductView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct SellProductView: View {
    @EnvironmentObject var store: ProductStore

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var selectedLocation: String = "Jaipur"
    @State private var selectedCategory = "Electronics"


    // to show a little success message after adding
    @State private var showSuccess: Bool = false
    let locations: [String] = [
          "Jaipur",
          "Mobiles",
          "Cars",
          "Furniture",
          "Fashion"
      ]
    let categories = [
        "Electronics",
        "Mobiles",
        "Cars",
        "Furniture",
        "Fashion"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Product Info") {
                    TextField("Product name", text: $name)
                    TextField("Category", text: $category)
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
                
                Section {
                    Button {
                        addProduct()
                    } label: {
                        Text("Add Product")
                            .frame(maxWidth: .infinity)
                            .fontWeight(.semibold)
                    }
                    .disabled(!isFormValid())
                }

                if showSuccess {
                    Text("Product added! Check the Home tab.")
                        .foregroundColor(.green)
                }
            }
            .navigationTitle("Sell Product")
        }
    }

    // Only allow adding if name and price are filled and price is a number
    func isFormValid() -> Bool {
        return !name.isEmpty && Double(price) != nil
    }

    func addProduct() {

        // price is a string so we convert it to a number
        let priceValue = Double(price) ?? 0.0

        store.addProduct(
            name: name,
            category: category.isEmpty ? "Other" : category,
            price: priceValue,
            description: description,
            location: selectedLocation
        )

        // clear the form
        name = ""
        category = ""
        price = ""
        description = ""

        showSuccess = true
    }
}

#Preview {
    SellProductView()
        .environmentObject(ProductStore())
}
