//
//  ExploreShopsSection.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct ExploreShopsSection: View {
    let shops = [
        ShopItem(name: "Bobbi Brown", imageName: "bobi", backgroundColor: Color(red: 0.8, green: 0.6, blue: 0.5)),
        ShopItem(name: "Valentino", imageName: "valentino", backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95)),
        ShopItem(name: "Dior", imageName: "dior", backgroundColor: Color.black)
    ]
    
    @State private var showComingSoonModal = false // Add this state variable
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack {
                Text("EXPLORE THE SHOPS")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .tracking(0.5)
                
                Spacer()
                
                Button("View All") {
                    showComingSoonModal = true // Show modal when "View All" is tapped
                }
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            }
            
            // Horizontal Scrolling Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(shops, id: \.name) { shop in
                        Button {
                            showComingSoonModal = true // Show modal when card is tapped
                        } label: {
                            ShopCard(shop: shop)
                        }
                        .buttonStyle(.plain) // Removes button styling
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
        .sheet(isPresented: $showComingSoonModal) {
            ComingSoonModal()
                .presentationDetents([.fraction(0.3)]) // Adjust modal height
        }
    }
}

// Add this new view for the modal content
struct ComingSoonModal: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hourglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("Coming Soon")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("This feature is currently in development and will be available in a future update.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
        }
        .padding()
    }
}
