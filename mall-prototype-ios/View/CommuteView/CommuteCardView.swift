//
//  CommuteCardView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct CommuteCardView: View {
    let imageName: String
    let title: String
    let description: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
            
            // Black overlay
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.35)
                .frame(height: 180)
            
            // Text overlay
            VStack(alignment: .leading, spacing: 4) {
                Text(description.uppercased())
                    .font(.caption)
                    .foregroundColor(.white)
                    .opacity(0.9)
                
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(height: 180)
        .background(Color.black) // fallback background
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 3)
        .padding(.horizontal)
    }
}

