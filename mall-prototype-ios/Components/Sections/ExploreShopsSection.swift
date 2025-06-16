//
//  ExploreShopsSection.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct ExploreShopsSection: View {
    let shops = [
        ShopItem(name: "Bobbi Brown", imageName: "bobbi_brown", backgroundColor: Color(red: 0.8, green: 0.6, blue: 0.5)),
        ShopItem(name: "Valentino", imageName: "valentino", backgroundColor: Color(red: 0.95, green: 0.95, blue: 0.95)),
        ShopItem(name: "Dior", imageName: "dior", backgroundColor: Color.black)
    ]
    
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
                    // Action for view all
                }
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
            }
            
            // Horizontal Scrolling Cards
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(shops, id: \.name) { shop in
                        ShopCard(shop: shop)
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
    }
}