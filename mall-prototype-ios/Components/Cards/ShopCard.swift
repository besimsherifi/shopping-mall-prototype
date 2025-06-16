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
            // Image Container
            RoundedRectangle(cornerRadius: 12)
                .fill(shop.backgroundColor)
                .frame(width: 140, height: 140)
                .overlay(
                    // Placeholder for actual image
                    VStack {
                        Image(systemName: "bag.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(shop.name.prefix(1))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                )
            
            // Shop Name
            Text(shop.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
}