//
//  ExploreView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @State private var selectedCategory = 0
    @State private var showingFilters = false
    @State private var showComingSoonModal = false
    
    private let categories = ["All", "Shopping", "Dining", "Entertainment", "Services", "Events"]
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    // Search Bar
                    searchSection
                    
                    // Category Filter
                    categoryFilterSection
                    
                    // Featured Banner
                    featuredBannerSection
                    
                    // What's New Section
                    whatsNewSection
                    
                    // Categories Grid
                    categoriesGridSection
                    
                    // Events & Experiences
                    eventsSection
                    
                    // Popular This Week
                    popularSection
                    
                    // Brands Directory
                    brandsDirectorySection
                    
                    // Bottom Padding
                    Spacer()
                        .frame(height: 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingFilters) {
            FilterView()
        }
    }
    
    private var searchSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search stores, restaurants, events...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button("Clear") {
                        searchText = ""
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
    
    private var categoryFilterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(categories[index]) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = index
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(selectedCategory == index ? Color.black : Color(.systemGray6))
                    .foregroundColor(selectedCategory == index ? .white : .primary)
                    .cornerRadius(20)
                    .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 16)
    }
    
    private var featuredBannerSection: some View {
        VStack(spacing: 0) {
            ZStack {
                // Festival Background Image (you'd need to add this to your assets)
                Image("festival")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .overlay(
                        Color.purple.opacity(0.3) // Tint to match your color scheme
                    )
                
                // Content remains the same
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                        Text("SUMMER FESTIVAL")
                        Image(systemName: "sparkles")
                    }
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    
                    Text("Discover amazing deals and experiences")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.9))
                    
                    Button("Explore Now") {
                                showComingSoonModal = true
                            }
                            .buttonStyle(FestivalButtonStyle())
                            .sheet(isPresented: $showComingSoonModal) {
                                ComingSoonModal()
                                    .presentationDetents([.fraction(0.3)])
                            }
                    .buttonStyle(FestivalButtonStyle())
                }
                .padding(.horizontal, 20)
            }
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
    }
    
    private var whatsNewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("WHAT'S NEW")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("See All") {
                    // Handle see all action
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(whatsNewItems, id: \.id) { item in
                        WhatsNewCard(item: item) {
                            showComingSoonModal = true
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
    private var categoriesGridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("EXPLORE BY CATEGORY")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(exploreCategories, id: \.id) { category in
                    ExploreCategoryCard(category: category)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("EVENTS & EXPERIENCES")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("View Calendar") {
                    // Handle calendar action
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(eventItems, id: \.id) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 24)
    }
    
    private var popularSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("POPULAR THIS WEEK")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
            
            VStack(spacing: 12) {
                ForEach(0..<5, id: \.self) { index in
                    PopularItemRow(
                        rank: index + 1,
                        name: popularItems[index].name,
                        category: popularItems[index].category,
                        rating: popularItems[index].rating,
                        image: popularItems[index].image
                    ){
                        showComingSoonModal = true
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
    }
    
    private var brandsDirectorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("BRANDS DIRECTORY")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button("A-Z List") {
                    // Handle directory action
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
                ForEach(brandLogos, id: \.id) { brand in
                    BrandLogoCard(brand: brand){
                        showComingSoonModal = true
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 24)
    }
}

// MARK: - Supporting Views

struct WhatsNewCard: View {
    let item: WhatsNewItem
    var action: () -> Void
    
    var body: some View {
            Button(action: action) {  // Wrap entire card in button
                VStack(alignment: .leading, spacing: 8) {
                    ZStack {
                        // Background Image with gradient overlay
                        Image(item.imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 120)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .cornerRadius(12)
                        
                        // Existing content overlay
                        VStack {
                            Image(systemName: item.icon)
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                            
                            if item.isNew {
                                Text("NEW")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                    
                    // Text content
                    Text(item.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    Text(item.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .frame(width: 160)
            }
            .buttonStyle(CardButtonStyle())  // Add custom button style
        }
    }

    // Custom button style to remove default button effects
    struct CardButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
                .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
                .contentShape(Rectangle())  // Make entire area tappable
        }
    }

struct ExploreCategoryCard: View {
    let category: ExploreCategory
    
    @State private var showComingSoonModal = false
    
    var body: some View {
        Button(action: {
            showComingSoonModal = true
        }) {
            VStack(spacing: 12) {
                ZStack {
                    // Background Image with overlay
                    Image(category.imageName) // Add imageName to your model
                        .resizable()
                        .scaledToFill()
                        .frame(height: 100)
                        .overlay(
                            Color.black.opacity(0.2) // Adjust opacity as needed
                                .cornerRadius(16)
                        )
                        .clipped()
                        .cornerRadius(16)
                    
                    // Existing content
                    VStack {
                        Image(systemName: category.icon)
                            .font(.system(size: 32))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                        
                        Text("\(category.count)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 1)
                    }
                }
                
                // Title remains unchanged
                Text(category.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showComingSoonModal) {
            ComingSoonModal()
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct EventCard: View {
    let event: EventItem
    
    @State private var showComingSoonModal = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                // Image Background with Gradient Overlay
                Image(event.imageName) // Add to your model
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 120)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, .black.opacity(0.2)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipped()
                    .cornerRadius(12)
                
                // Date Badge (unchanged)
                Text(event.date)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(8)
                    .padding(8)
            }
            
            // Text Content (unchanged)
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "mappin.circle.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.location)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(event.time)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .frame(width: 200)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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

struct PopularItemRow: View {
    let rank: Int
    let name: String
    let category: String
    let rating: Double
    let image: String
    var action: () -> Void  // Add action handler
    
    var body: some View {
        Button(action: action) {  // Wrap entire row in button
            HStack(spacing: 12) {
                // Rank Number
                Text("\(rank)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(width: 20)
                
                // Item Image
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: image)
                            .foregroundColor(.gray)
                    )
                
                // Item Info
                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Rating
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                    
                    Text(String(format: "%.1f", rating))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PopularItemButtonStyle())  // Custom button style
    }
}

// Custom button style for popular items
struct PopularItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .background(
                configuration.isPressed ?
                Color(.systemGray5).cornerRadius(12) :
                Color(.systemBackground).cornerRadius(12)
            )
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct BrandLogoCard: View {
    let brand: BrandLogo
    var action: () -> Void  // Add action handler
    
    var body: some View {
        Button(action: action) {  // Use the passed action
            VStack(spacing: 8) {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(brand.name.prefix(1))
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                    )
                
                Text(brand.name)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(BrandLogoButtonStyle())  // Custom button style
    }
}

// Custom button style for brand logos
struct BrandLogoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct FilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPrice = 0
    @State private var selectedDistance = 0
    @State private var selectedRating = 0
    
    private let priceRanges = ["Any", "$", "$$", "$$$", "$$$$"]
    private let distanceRanges = ["Any", "Nearby", "Same Floor", "Same Zone"]
    private let ratingOptions = ["Any", "4+ Stars", "4.5+ Stars", "5 Stars"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Price Range
                VStack(alignment: .leading, spacing: 12) {
                    Text("Price Range")
                        .font(.headline)
                    
                    HStack {
                        ForEach(0..<priceRanges.count, id: \.self) { index in
                            Button(priceRanges[index]) {
                                selectedPrice = index
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(selectedPrice == index ? Color.black : Color(.systemGray6))
                            .foregroundColor(selectedPrice == index ? .white : .primary)
                            .cornerRadius(8)
                        }
                    }
                }
                
                // Distance
                VStack(alignment: .leading, spacing: 12) {
                    Text("Distance")
                        .font(.headline)
                    
                    VStack {
                        ForEach(0..<distanceRanges.count, id: \.self) { index in
                            HStack {
                                Button(action: { selectedDistance = index }) {
                                    HStack {
                                        Image(systemName: selectedDistance == index ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedDistance == index ? .blue : .gray)
                                        
                                        Text(distanceRanges[index])
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                // Rating
                VStack(alignment: .leading, spacing: 12) {
                    Text("Rating")
                        .font(.headline)
                    
                    VStack {
                        ForEach(0..<ratingOptions.count, id: \.self) { index in
                            HStack {
                                Button(action: { selectedRating = index }) {
                                    HStack {
                                        Image(systemName: selectedRating == index ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selectedRating == index ? .blue : .gray)
                                        
                                        Text(ratingOptions[index])
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                
                Spacer()
                
                // Apply Button
                Button("Apply Filters") {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(20)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Data Models

struct WhatsNewItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let backgroundColor: Color
    let isNew: Bool
    let imageName: String
}

struct ExploreCategory: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let count: Int
    let backgroundColor: Color
    let imageName: String
}

struct EventItem: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let date: String
    let time: String
    let backgroundColor: Color
    let imageName: String
}

struct PopularItem {
    let name: String
    let category: String
    let rating: Double
    let image: String
}

struct BrandLogo: Identifiable {
    let id = UUID()
    let name: String
}

// MARK: - Sample Data

private let whatsNewItems = [
    WhatsNewItem(title: "VR Zone Opens", subtitle: "Level 2", icon: "visionpro", backgroundColor: .purple, isNew: true, imageName: "vr"),
    WhatsNewItem(title: "Artisan Bakery", subtitle: "Fresh Daily", icon: "birthday.cake", backgroundColor: .orange, isNew: true, imageName: "bakery"),
    WhatsNewItem(title: "Tech Store", subtitle: "Latest Gadgets", icon: "iphone", backgroundColor: .blue, isNew: false, imageName: "techstore"),
    WhatsNewItem(title: "Luxury Spa", subtitle: "Wellness Center", icon: "leaf", backgroundColor: .green, isNew: true, imageName: "spa")
]

private let exploreCategories = [
    ExploreCategory(title: "Fashion & Beauty", icon: "tshirt", count: 120, backgroundColor: .pink, imageName: "fashion"),
    ExploreCategory(title: "Food & Dining", icon: "fork.knife", count: 45, backgroundColor: .orange, imageName: "food"),
    ExploreCategory(title: "Entertainment", icon: "gamecontroller", count: 15, backgroundColor: .purple, imageName: "entertainment"),
    ExploreCategory(title: "Electronics", icon: "iphone", count: 28, backgroundColor: .blue, imageName: "electronics"),
    ExploreCategory(title: "Home & Living", icon: "house", count: 35, backgroundColor: .green, imageName: "homeliving"),
    ExploreCategory(title: "Kids & Family", icon: "figure.2.and.child.holdinghands", count: 22, backgroundColor: .yellow, imageName: "kidsplay")
]

private let eventItems = [
    EventItem(title: "Summer Fashion Show", location: "Atrium", date: "Jun 15", time: "7:00 PM", backgroundColor: .pink, imageName: "fashionshow"),
    EventItem(title: "Kids Workshop", location: "Level 1", date: "Jun 16", time: "2:00 PM", backgroundColor: .yellow, imageName: "kidsworkshop"),
    EventItem(title: "Live Music Night", location: "Food Court", date: "Jun 17", time: "8:00 PM", backgroundColor: .purple, imageName: "livemusic"),
    EventItem(title: "Art Exhibition", location: "Gallery", date: "Jun 18", time: "All Day", backgroundColor: .blue, imageName: "art")
]

private let popularItems = [
    PopularItem(name: "Apple Store", category: "Electronics", rating: 4.8, image: "iphone"),
    PopularItem(name: "Zara", category: "Fashion", rating: 4.6, image: "tshirt"),
    PopularItem(name: "Starbucks", category: "Coffee", rating: 4.5, image: "cup.and.saucer"),
    PopularItem(name: "H&M", category: "Fashion", rating: 4.4, image: "tshirt"),
    PopularItem(name: "McDonald's", category: "Fast Food", rating: 4.2, image: "fork.knife")
]

private let brandLogos = [
    BrandLogo(name: "Nike"), BrandLogo(name: "Adidas"), BrandLogo(name: "Gucci"), BrandLogo(name: "Prada"),
    BrandLogo(name: "Dior"), BrandLogo(name: "Chanel"), BrandLogo(name: "LV"), BrandLogo(name: "Rolex"),
    BrandLogo(name: "Apple"), BrandLogo(name: "Samsung"), BrandLogo(name: "Sony"), BrandLogo(name: "Bose")
]

// MARK: - Integration

// Update your MainView switch statement:
// case 2: ExploreView()
struct FestivalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.white)
            .foregroundColor(.purple) // Changed to match theme
            .cornerRadius(25)
            .font(.system(size: 16, weight: .semibold))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
