//
//  CategoryView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

// Shows all products that belong to one category.
struct CategoryView: View {
    @EnvironmentObject var store: ProductStore
    let category: String

    var products: [Product] {
        store.products.filter { $0.category == category }
    }

    var body: some View {
        List(products) { product in
            NavigationLink(destination: ProductDetailView(product: product)) {
                HStack(spacing: 16) {
                    Image(systemName: product.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)

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
        .navigationTitle(category)
    }
}

#Preview {
    NavigationStack {
        CategoryView(category: "Mobiles")
            .environmentObject(ProductStore())
    }
}
