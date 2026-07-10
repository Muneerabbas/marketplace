//
//  ProductDetailView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject var auth: AuthViewModel
    @EnvironmentObject var store: ProductStore

    let product: Product

    @State private var isPurchasing = false
    @State private var purchaseMessage: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                Image(systemName: product.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)

                Text(product.category)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.red)
                    .cornerRadius(8)

                Text("$\(product.price, specifier: "%.0f")")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)

                Divider()

                HStack {
                    Text("Category:")
                        .font(.headline)
                    Text(product.category)
                        .font(.body)
                }

                HStack {
                    Text("Location:")
                        .font(.headline)
                    Text(product.location)
                        .font(.body)
                }

                Text("Description")
                    .font(.headline)
                Text(product.description.isEmpty ? "No description provided." : product.description)
                    .font(.body)
                    .foregroundColor(.gray)

                if let purchaseMessage {
                    Text(purchaseMessage)
                        .font(.footnote)
                        .foregroundColor(purchaseMessage.contains("success") ? .green : .red)
                }

                if let error = store.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                }

                Spacer()

                Button {
                    Task {
                        await buyProduct()
                    }
                } label: {
                    if isPurchasing {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Buy Now")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.red)
                .cornerRadius(10)
                .disabled(isPurchasing || auth.currentUser == nil)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func buyProduct() async {
        guard let user = auth.currentUser else {
            purchaseMessage = "Please log in to buy."
            return
        }

        isPurchasing = true
        purchaseMessage = nil

        if let updatedUser = await store.purchaseProduct(productId: product.id, userId: user.id) {
            auth.updateCurrentUser(updatedUser)
            purchaseMessage = "Purchase successful!"
        }

        isPurchasing = false
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.sampleProducts[0])
            .environmentObject(AuthViewModel())
            .environmentObject(ProductStore())
    }
}
