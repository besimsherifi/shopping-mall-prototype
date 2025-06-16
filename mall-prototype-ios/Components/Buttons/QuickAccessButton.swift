//
//  QuickAccessButton.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct QuickAccessButton: View {
    let item: QuickAccessItem
    
    var body: some View {
        VStack(spacing: 12) {
            // Circular Icon Background
            ZStack {
                Circle()
                    .fill(item.backgroundColor)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundColor(.black)
            }
            
            // Title Text
            Text(item.title)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .onTapGesture {
            print("Tapped: \(item.title)")
        }
    }
}