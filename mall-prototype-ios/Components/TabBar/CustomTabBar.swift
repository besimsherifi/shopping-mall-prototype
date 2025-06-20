//
//  CustomTabBar.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedIndex: Int
    let items: [TabBarItem]
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.3))
            
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedIndex = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            // Animated icon
                            if index == 3 {
                                Image(systemName: selectedIndex == index ? items[index].selectedIcon : items[index].icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .scaleEffect(selectedIndex == index ? 1.15 : 1.0)
                            } else {
                                Image(selectedIndex == index ? items[index].selectedIcon : items[index].icon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .scaleEffect(selectedIndex == index ? 1.15 : 1.0)
                            }
                            
                            // Text with weight transition
                            Text(items[index].title)
                                .font(.system(
                                    size: 11,
                                    weight: selectedIndex == index ? .medium : .light
                                ))
                        }
                        .foregroundColor(selectedIndex == index ? .black : .gray)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(TabBarButtonStyle())
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 8)
            .background(Color.white)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct TabBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
