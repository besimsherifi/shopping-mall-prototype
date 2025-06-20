//
//  DubaiMallTopBar.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct DubaiMallTopBar: View {
    @State private var isSearchPresented = false
    @State private var isNotificationsPresented = false
    var onCategoryTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                // Search Button
                Button(action: {
                    isSearchPresented = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fontWeight(.ultraLight)
                }

                Spacer()

                // Centered title
                Text("SHOPPING MALL")
                    .font(.system(size: 16, weight: .medium))
                    .kerning(1.5)
                    .foregroundColor(.black)

                Spacer()

                // Notifications Button
                Button(action: {
                    isNotificationsPresented = true
                }) {
                    Image(systemName: "bell")
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                        .fontWeight(.ultraLight)
                }
            }
            .padding(.horizontal)
            .padding(.top, 50)
            .padding(.bottom, 8)

            // Horizontal Menu
            HStack(spacing: 32) {
                ForEach(["SHOP", "DINE", "ENTERTAIN"], id: \.self) { category in
                    Button(action: {
                        onCategoryTap?() // Trigger the navigation
                    }) {
                        Text(category)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.black)

            Divider()
        }
        .background(Color.white)
        // Present modals or sheets
        .sheet(isPresented: $isSearchPresented) {
            SearchView()
        }
        .sheet(isPresented: $isNotificationsPresented) {
            NotificationsView()
        }
    }
}


struct Store: Identifiable {
    let id = UUID()
    let name: String
    let floor: String
    let logoName: String // Asset name of the store image
}

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var query: String = ""
    
    let stores: [Store] = [
        Store(name: "Zara", floor: "First Floor", logoName: "zara"),
        Store(name: "H&M", floor: "Ground Floor", logoName: "hm"),
        Store(name: "Lego", floor: "First Floor", logoName: "lego"),
        Store(name: "Apple", floor: "First Floor", logoName: "apple"),
        Store(name: "Gant", floor: "First Floor", logoName: "gant"),
        Store(name: "Calvin Klein", floor: "Second Floor", logoName: "calvinklein"),
        Store(name: "Tommy", floor: "Second Floor", logoName: "tommy"),
        Store(name: "Nike", floor: "First Floor", logoName: "nike"),
        Store(name: "Armani", floor: "First Floor", logoName: "armani"),
        Store(name: "Starbucks", floor: "First Floor", logoName: "starbuk"),
    ]
    
    var filteredStores: [Store] {
        if query.isEmpty {
            return stores
        } else {
            return stores.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                            .padding(.leading)
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $query)
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        if !query.isEmpty {
                            Button(action: {
                                query = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.trailing)
                }
                .padding(.vertical, 10)
                .background(Color.white)
                
                Divider()
                
                List(filteredStores) { store in
                    HStack {
                        Image(store.logoName)
                            .resizable()
                            .frame(width: 48, height: 48)
                            .cornerRadius(4)

                        VStack(alignment: .leading) {
                            Text(store.name)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Text(store.floor)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: "figure.walk")
                            .resizable()
                            .frame(width: 20, height: 30)
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let imageName: String // Name of the image in Assets.xcassets
    let timestamp: String
}

struct NotificationsView: View {
    let notifications: [NotificationItem] = [
        NotificationItem(
            title: "ZARA Mid-Season Sale",
            message: "Enjoy up to 50% off on selected items until Sunday.",
            imageName: "zara", // Example asset name
            timestamp: "10 min ago"
        ),
        NotificationItem(
            title: "New Drinks @ Starbucks",
            message: "Try our summer mango frappuccino, now available!",
            imageName: "starbuk",
            timestamp: "1 hr ago"
        ),
        NotificationItem(
            title: "Apple Store Workshop",
            message: "Join the iPhone photography session at 4 PM today.",
            imageName: "apple",
            timestamp: "Today"
        ),
        NotificationItem(
            title: "LEGO Contest",
            message: "Build & win! LEGO challenge at 3 PM, Zone C.",
            imageName: "lego",
            timestamp: "Today"
        ),
        NotificationItem(
            title: "Nike Member Offer",
            message: "Get 20% off on new arrivals this weekend only.",
            imageName: "nike",
            timestamp: "Yesterday"
        )
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(notifications) { item in
                        HStack(alignment: .top, spacing: 12) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                                .clipped()

                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.title)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.black)

                                Text(item.message)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)

                                Text(item.timestamp)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Notifications")
        }
    }
}
