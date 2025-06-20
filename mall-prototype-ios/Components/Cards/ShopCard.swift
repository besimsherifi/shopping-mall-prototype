//
//  ShopCard.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct ShopCard: View {
    let shop: ShopItem

    var body: some View {
        VStack(spacing: 8) {
            // Image as Card Cover
            Image(shop.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 140)
                .clipped()
                .cornerRadius(12)
                .overlay( // Border
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 3)

            // Shop Name
            Text(shop.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
}
