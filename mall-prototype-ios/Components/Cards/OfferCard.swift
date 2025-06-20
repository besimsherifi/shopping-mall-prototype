//
//  OfferCard.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct OfferCard: View {
    let imageName: String
    let title: String
    let mainText: String
    let subText: String
    let dateRange: String
    
    @State private var showComingSoonModal = false

    var body: some View {
        ZStack {
            // Local Image as background
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 160)
                .clipped()
                .cornerRadius(12)

            // Dark gradient overlay
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(12)
                .frame(width: 280, height: 160)

            // Content Overlay
            VStack(alignment: .leading, spacing: 4) {
                // Top title
                HStack {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .textCase(.uppercase)
                    Spacer()
                }

                Spacer()

                VStack(alignment: .leading, spacing: 2) {
                    Text(mainText)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(subText)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(dateRange)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .textCase(.uppercase)
                        .padding(.top, 4)
                }
            }
            .padding(16)
        }
        .frame(width: 280, height: 160)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onTapGesture {
            showComingSoonModal = true
        }
        .sheet(isPresented: $showComingSoonModal) {
            ComingSoonModal()
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
        }
    }
}
