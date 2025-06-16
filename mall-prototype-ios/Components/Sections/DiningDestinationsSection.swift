//
//  DiningDestinationsSection.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct DiningDestinationsSection: View {
    let restaurants = [
        RestaurantItem(name: "Social House", imageName: "social_house", backgroundColor: Color(red: 0.9, green: 0.7, blue: 0.4)),
        RestaurantItem(name: "Parker's", imageName: "parkers", backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.85)),
        RestaurantItem(name: "Hai Di Lao", imageName: "hai_di_lao", backgroundColor: Color.black)
    ]
    
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
                    // Action for view all
                }
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            }
            
            // Horizontal Scrolling Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(restaurants, id: \.name) { restaurant in
                        RestaurantCard(restaurant: restaurant)
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
    }
}