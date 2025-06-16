//
//  MainView.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0

    private let tabs = [
        TabBarItem(icon: "home", selectedIcon: "homefill", title: "Home"),
        TabBarItem(icon: "person", selectedIcon: "personfill", title: "Navigate"),
        TabBarItem(icon: "explore", selectedIcon: "explorefill", title: "Explore"),
        TabBarItem(icon: "car", selectedIcon: "car.fill", title: "Commute"),
        TabBarItem(icon: "more", selectedIcon: "morefill", title: "More")
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0: HomeView()
                case 1: NavigateView()
                case 2: ExploreView()
                case 3: CommuteView()
                case 4: MoreView()
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())

            CustomTabBar(selectedIndex: $selectedTab, items: tabs)
        }
    }
}