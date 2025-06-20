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
            // Image as Card Cover
            Image(restaurant.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .clipped()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)

            // Restaurant Name
            Text(restaurant.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
}
