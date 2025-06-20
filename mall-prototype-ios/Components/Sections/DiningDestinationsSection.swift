//
//  DiningDestinationsSection.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct DiningDestinationsSection: View {
    let restaurants = [
        RestaurantItem(name: "Dominos", imageName: "dominos", backgroundColor: Color(red: 0.9, green: 0.7, blue: 0.4)),
        RestaurantItem(name: "KFC", imageName: "kfc", backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.85)),
        RestaurantItem(name: "Sarajeva", imageName: "sarajeva", backgroundColor: Color.black)
    ]
    
    @State private var showComingSoonModal = false // Add state for modal control
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack {
                Text("DINING DESTINATIONS")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .tracking(0.5)
                
                Spacer()
                
                Button("View All") {
                    showComingSoonModal = true // Show modal when tapped
                }
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            }
            
            // Horizontal Scrolling Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants, id: \.name) { restaurant in
                        Button {
                            showComingSoonModal = true // Show modal when card is tapped
                        } label: {
                            RestaurantCard(restaurant: restaurant)
                        }
                        .buttonStyle(.plain) // Maintain original card styling
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
        .sheet(isPresented: $showComingSoonModal) {
            ComingSoonModal() // Reuse the same modal component
                .presentationDetents([.fraction(0.3)]) // Consistent modal size
        }
    }
}
