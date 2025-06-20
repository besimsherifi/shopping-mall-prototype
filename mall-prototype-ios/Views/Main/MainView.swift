//
//  MainView.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @Namespace private var animationNamespace // For matched geometry effect
    
    private let tabs = [
        TabBarItem(icon: "home", selectedIcon: "homefill", title: "Home"),
        TabBarItem(icon: "person", selectedIcon: "personfill", title: "Navigate"),
        TabBarItem(icon: "explore", selectedIcon: "explorefill", title: "Explore"),
        TabBarItem(icon: "car", selectedIcon: "car.fill", title: "Commute"),
        TabBarItem(icon: "more", selectedIcon: "morefill", title: "More")
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab Content with Transition
            Group {
                switch selectedTab {
                case 0:
                    HomeView(selectedTab: $selectedTab)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)
                        ))
                case 1:
                    NavigateView()
                        .transition(.opacity)
                case 2:
                    ExploreView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                case 3:
                    NavigationView { CommuteView() }
                        .transition(.scale)
                case 4:
                    MoreView()
                        .transition(.opacity)
                default:
                    HomeView(selectedTab: $selectedTab)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .animation(.easeInOut(duration: 0.3), value: selectedTab) // Add animation
            
            // Custom Tab Bar
            CustomTabBar(selectedIndex: $selectedTab, items: tabs)
        }
    }
}
