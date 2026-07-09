//
//  ProductDetailView.swift
//  Marketplace
//
//  Created by Muneer Abass on 08/07/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Big product icon
                Image(systemName: product.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                // Name
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)

                // Category badge
                Text(product.category)
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(8)

                // Price
                Text("$\(product.price, specifier: "%.0f")")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                Divider()


                HStack{
                    
                    Text("Category:")
                        .font(.headline)

                    Text(product.category)
                        .font(.body)
                    
                }
                HStack{
                    
                    Text("Location:")
                        .font(.headline)

                    Text(product.location)
                        .font(.body)
                    
                }



                // Description
                Text("Description")
                    .font(.headline)
                Text(product.description)
                    .font(.body)
                    .foregroundColor(.gray)

                
                
                Spacer()

                // Buy button (does nothing for now)
                
                Button {
                    // TODO: add buy logic later
                } label: {
                    Text("Buy Now")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.sampleProducts[0])
    }
}
