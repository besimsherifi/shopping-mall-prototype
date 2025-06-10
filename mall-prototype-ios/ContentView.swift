//
//  ContentView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 21.5.25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var showMainView = false

    var body: some View {
        Group {
            if showMainView {
                MainView()
            } else {
                IntroPage(onFinish: {
                    withAnimation {
                        showMainView = true
                    }
                })
            }
        }
    }
}

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

struct HomeView: View {
    @State private var player = AVPlayer()
    
    let quickAccessItems = [
            QuickAccessItem(icon: "airplane", title: "Emirates\nSkywards", backgroundColor: Color(.systemGray6)),
            QuickAccessItem(icon: "figure.walk", title: "Find\nwashroom", backgroundColor: Color(.systemGray6)),
            QuickAccessItem(icon: "giftcard", title: "Emaar Gift\nCard", backgroundColor: Color(.systemGray6)),
            QuickAccessItem(icon: "wifi", title: "Free Wifi", backgroundColor: Color(.systemGray6)),
            QuickAccessItem(icon: "car.fill", title: "Find My Car", backgroundColor: Color(.systemGray6)),
            QuickAccessItem(icon: "bag.fill", title: "Personal\nShopping", backgroundColor: Color(.systemGray6))
        ]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                Spacer()
                // Sticky top bar
                DubaiMallTopBar()
                
                // Scrollable content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Video Player - Full Screen Width
                        VideoPlayer(player: player)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                            .clipped()
                            .edgesIgnoringSafeArea(.horizontal)
                            .onAppear {
                                setupVideo()
                            }
                            .onDisappear {
                                player.pause()
                            }
                        
                        VStack(alignment: .leading, spacing: 16) {
                                    // Header
                                    HStack {
                                        Text("TRENDING OFFERS")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        
                                        Button("View All") {
                                            // Handle view all action
                                        }
                                        .font(.subheadline)
                                        .fontWeight(.regular)
                                        .foregroundColor(.gray)
                                        .underline()
                                    }
                                    .padding(.horizontal, 20)
                                    
                                    // Offers ScrollView
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 16) {
                                            // Aquarium Offer Card
                                            OfferCard(
                                                imageName: "aquarium_bg", // Replace with your image name
                                                title: "DUBAI AQUARIUM & UNDERWA...",
                                                mainText: "Flash Sale Alert:",
                                                subText: "Summer Fun Pass!",
                                                dateRange: "19 MAY - 4 JUN"
                                            )
                                            
                                            // House of Hype Card
                                            OfferCard(
                                                imageName: "hype_bg", // Replace with your image name
                                                title: "HOUSE OF HYPE",
                                                mainText: "Squad Pass at Hou",
                                                subText: "Hype!",
                                                dateRange: "1 MAY - 31 DEC"
                                            )
                                            
                                            OfferCard(
                                                imageName: "hype_bg", // Replace with your image name
                                                title: "HOUSE OF MUSIC",
                                                mainText: "The Summer hits are here",
                                                subText: "Hype!",
                                                dateRange: "1 June - 31 July"
                                            )
                                            
                                            // Add more cards as needed
                                        }
                                        .padding(.horizontal, 20)
                                    }
                                }
                                
                            
                        Divider()

                        
                        VStack(alignment: .leading, spacing: 20) {
                                    // Section Title
                                    Text("QUICK ACCESS")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 20)
                                    
                                    // Grid of Quick Access Items
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 30) {
                                        ForEach(quickAccessItems) { item in
                                            QuickAccessButton(item: item)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                                .padding(.vertical, 10)
                        Divider()
                        
                        
                        
                        ScrollView {
                                    VStack(spacing: 30) {
                                        // Explore the Shops Section
                                        ExploreShopsSection()
                                        
                                        // Dining Destinations Section
                                        DiningDestinationsSection()
                                        
                                        Spacer(minLength: 100)
                                    }
                                    .padding(.horizontal, 16)
                                }
                                .background(Color(.systemBackground))
                        
                        
                        
                        
                        // Bottom padding to account for tab bar
                        Spacer()
                            .frame(height: 100)
                    }
                }
            }
            .background(.white)

            WhatsAppButton()
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    private func setupVideo() {
        // Replace "video" with your actual video file name and extension
        guard let videoURL = Bundle.main.url(forResource: "video1", withExtension: "mp4") else {
            print("Video file not found")
            return
        }
        
        player = AVPlayer(url: videoURL)
        player.play()
    }
}


struct OfferCard: View {
    let imageName: String
    let title: String
    let mainText: String
    let subText: String
    let dateRange: String
    
    var body: some View {
        ZStack {
            // Background Image
            AsyncImage(url: URL(string: imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                // Placeholder with gradient background
                LinearGradient(
                    colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .frame(width: 280, height: 160)
            .clipped()
            .cornerRadius(12)
            
            // Dark overlay for text readability
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(12)
            
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
                
                // Main content at bottom
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
    }
}

// Sample data structure for offers
struct Offer {
    let id = UUID()
    let imageName: String
    let title: String
    let mainText: String
    let subText: String
    let dateRange: String
}
struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

struct TabBarItem {
    let icon: String
    let selectedIcon: String
    let title: String
}

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

struct WhatsAppButton: View {
    var body: some View {
        Button(action: {
            // Handle WhatsApp action
        }) {
            Image("whatsapp")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .padding(.trailing, 16)
        .padding(.bottom, 100)
    }
}

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
            // Handle tap action
            print("Tapped: \(item.title)")
        }
    }
}

struct QuickAccessItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let backgroundColor: Color
}

// Custom icons view for more accurate representation
struct QuickAccessViewWithCustomIcons: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section Title
            Text("QUICK ACCESS")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            // Grid of Quick Access Items
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 30) {
                
                // Emirates Skywards
                QuickAccessCustomButton(
                    iconView: AnyView(
                        Text("✈️")
                            .font(.title2)
                    ),
                    title: "Fly\nSkywards"
                )
                
                // Find Washroom
                QuickAccessCustomButton(
                    iconView: AnyView(
                        HStack(spacing: 2) {
                            Image(systemName: "figure.stand")
                                .font(.caption)
                            Image(systemName: "figure.dress.line.vertical.figure")
                                .font(.caption)
                        }
                        .foregroundColor(.black)
                    ),
                    title: "Find\nwashroom"
                )
                
                // Emaar Gift Card
                QuickAccessCustomButton(
                    iconView: AnyView(
                        Image(systemName: "creditcard.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    ),
                    title: "Emaar Gift\nCard"
                )
                
                // Free Wifi
                QuickAccessCustomButton(
                    iconView: AnyView(
                        Image(systemName: "wifi")
                            .font(.title2)
                            .foregroundColor(.black)
                    ),
                    title: "Free Wifi"
                )
                
                // Find My Car
                QuickAccessCustomButton(
                    iconView: AnyView(
                        HStack(spacing: 1) {
                            Image(systemName: "car.fill")
                                .font(.caption)
                            Image(systemName: "magnifyingglass")
                                .font(.caption2)
                        }
                        .foregroundColor(.black)
                    ),
                    title: "Find My Car"
                )
                
                // Personal Shopping
                QuickAccessCustomButton(
                    iconView: AnyView(
                        Image(systemName: "bag.fill")
                            .font(.title3)
                            .foregroundColor(.black)
                    ),
                    title: "Personal\nShopping"
                )
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
    }
}

struct QuickAccessCustomButton: View {
    let iconView: AnyView
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            // Circular Icon Background
            ZStack {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 70, height: 70)
                
                iconView
            }
            
            // Title Text
            Text(title)
                .font(.system(size: 14))
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .onTapGesture {
            // Handle tap action
            print("Tapped: \(title)")
        }
    }
}


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

struct DiningDestinationsSection: View {
    let restaurants = [
        RestaurantItem(name: "Social House", imageName: "social_house", backgroundColor: Color(red: 0.9, green: 0.7, blue: 0.4)),
        RestaurantItem(name: "Parker's", imageName: "parkers", backgroundColor: Color(red: 0.85, green: 0.9, blue: 0.85)),
        RestaurantItem(name: "Hai Di Lao", imageName: "hai_di_lao", backgroundColor: Color.black)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Header
            HStack {
                Text("DINING DESTINATIONS")
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
                    ForEach(restaurants, id: \.name) { restaurant in
                        RestaurantCard(restaurant: restaurant)
                    }
                }
                .padding(.horizontal, 16)
            }
            .scrollClipDisabled()
            .padding(.horizontal, -16)
        }
    }
}

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

struct RestaurantCard: View {
    let restaurant: RestaurantItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Image Container
            RoundedRectangle(cornerRadius: 12)
                .fill(restaurant.backgroundColor)
                .frame(width: 140, height: 140)
                .overlay(
                    // Placeholder for actual image
                    VStack {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text(restaurant.name.prefix(1))
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                )
            
            // Restaurant Name
            Text(restaurant.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
}

// Data Models
struct ShopItem {
    let name: String
    let imageName: String
    let backgroundColor: Color
}

struct RestaurantItem {
    let name: String
    let imageName: String
    let backgroundColor: Color
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// MARK: - Enhanced Version with Real Images Support

struct EnhancedShopCard: View {
    let shop: ShopItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Image Container with AsyncImage support
            RoundedRectangle(cornerRadius: 12)
                .fill(shop.backgroundColor)
                .frame(width: 140, height: 140)
                .overlay(
                    Group {
                        // If you have actual images, replace this with:
                        // AsyncImage(url: URL(string: shop.imageURL)) { image in
                        //     image
                        //         .resizable()
                        //         .aspectRatio(contentMode: .fill)
                        // } placeholder: {
                        //     ProgressView()
                        // }
                        
                        // For now, using SF Symbols as placeholders
                        VStack {
                            Image(systemName: getShopIcon(for: shop.name))
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.9))
                            
                            if shop.name == "Valentino" {
                                Text("DUBAI MALL")
                                    .font(.system(size: 8, weight: .medium))
                                    .foregroundColor(.black.opacity(0.6))
                                    .padding(.top, 4)
                                
                                Text("EMAAR")
                                    .font(.system(size: 6, weight: .regular))
                                    .foregroundColor(.black.opacity(0.4))
                            }
                        }
                    }
                )
                .clipped()
            
            // Shop Name
            Text(shop.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
    
    private func getShopIcon(for shopName: String) -> String {
        switch shopName.lowercased() {
        case "bobbi brown":
            return "paintbrush.fill"
        case "valentino":
            return "v.circle.fill"
        case "dior":
            return "d.circle.fill"
        default:
            return "bag.fill"
        }
    }
}

struct EnhancedRestaurantCard: View {
    let restaurant: RestaurantItem
    
    var body: some View {
        VStack(spacing: 8) {
            // Image Container
            RoundedRectangle(cornerRadius: 12)
                .fill(restaurant.backgroundColor)
                .frame(width: 140, height: 140)
                .overlay(
                    Group {
                        // Placeholder for actual food images
                        VStack {
                            Image(systemName: getRestaurantIcon(for: restaurant.name))
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                )
                .clipped()
            
            // Restaurant Name
            Text(restaurant.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 140)
    }
    
    private func getRestaurantIcon(for restaurantName: String) -> String {
        switch restaurantName.lowercased() {
        case "social house":
            return "wineglass.fill"
        case "parker's":
            return "cup.and.saucer.fill"
        case "hai di lao":
            return "flame.fill"
        default:
            return "fork.knife"
        }
    }
}
