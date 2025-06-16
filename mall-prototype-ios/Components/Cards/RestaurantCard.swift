//
//  RestaurantCard.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct RestaurantCard: View {
    let restaurant: RestaurantItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Image Container
            RoundedRectangle(cornerRadius: 12)
                .fill(restaurant.backgroundColor)
                .frame(width: 140, height: 140)
                .overlay(
                    // Placeholder for actual image
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(restaurant.name.prefix(1))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                )
            
            // Restaurant Name
            Text(restaurant.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
}