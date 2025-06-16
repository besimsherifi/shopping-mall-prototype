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
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Spacer()
                    Button(action: {
                        selectedIndex = index
                    }) {
                        VStack(spacing: 4) {
                            if index == 3 {
                                Image(systemName: selectedIndex == index ? items[index].selectedIcon : items[index].icon)
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(selectedIndex == index ? .black : .gray)
                            } else {
                                Image(selectedIndex == index ? items[index].selectedIcon : items[index].icon)
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(selectedIndex == index ? .black : .gray)
                            }
                            Text(items[index].title)
                                .font(.system(size: 11, weight: .light))
                                .foregroundColor(selectedIndex == index ? .black : .gray)
                        }
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 10)
            .background(Color.white)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}