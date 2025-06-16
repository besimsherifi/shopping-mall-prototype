//
//  DubaiMallTopBar.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct DubaiMallTopBar: View {
    var body: some View {
        VStack(spacing: 18) {
            HStack {
                // Search icon
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .fontWeight(.ultraLight)
                Spacer()

                // Centered title
                Text("SHOPPING MALL")
                    .font(.system(size: 16, weight: .medium))
                    .kerning(1.5)
                    .foregroundColor(.black)

                Spacer()

                // Bell icon
                Image(systemName: "bell")
                    .font(.system(size: 18))
                    .foregroundColor(.black)
                    .fontWeight(.ultraLight)
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 8)

            // Horizontal Menu
            HStack(spacing: 32) {
                Text("SHOP")
                Text("DINE")
                Text("ENTERTAIN")
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.black)

            Divider()
        }
        .background(Color.white)
    }
}