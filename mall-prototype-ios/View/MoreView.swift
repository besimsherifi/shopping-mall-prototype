//
//  MoreView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI

struct MoreView: View {
    @State private var showingProfile = false
    @State private var showingNotifications = false
    @State private var showingLanguage = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Section
                    profileSection
                    
                    // Services Section
                    servicesSection
                    
                    // Information Section
                    informationSection
                    
                    // Shopping Features
                    shoppingSection
                    
                    // Support Section
                    supportSection
                    
                    // Settings Section
                    settingsSection
                    
                    // About Section
                    aboutSection
                }
                .padding()
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var profileSection: some View {
        VStack(spacing: 16) {
            HStack {
                // Profile Avatar
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.gold, .orange]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text("JD")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("John Doe")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Gold Member")
                        .font(.subheadline)
                        .foregroundColor(.gold)
                    Text("2,450 Points Available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { showingProfile = true }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Services")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ServiceCard(icon: "car.2.fill", title: "Valet Parking", color: .purple)
                ServiceCard(icon: "bag.fill", title: "Personal Shopper", color: .pink)
                ServiceCard(icon: "stroller.fill", title: "Stroller Rental", color: .blue)
                ServiceCard(icon: "wheelchair", title: "Accessibility", color: .green)
                ServiceCard(icon: "gift.fill", title: "Gift Cards", color: .red)
                ServiceCard(icon: "cube.box.fill", title: "Locker Service", color: .orange)
            }
        }
    }
    
    private var informationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Information")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                InfoRow(icon: "map.fill", title: "Interactive Map", subtitle: "Navigate the mall easily")
                Divider().padding(.leading, 44)
                InfoRow(icon: "calendar", title: "Events & Shows", subtitle: "What's happening today")
                Divider().padding(.leading, 44)
                InfoRow(icon: "clock.fill", title: "Opening Hours", subtitle: "Daily 10 AM - 12 AM")
                Divider().padding(.leading, 44)
                InfoRow(icon: "wifi", title: "Free WiFi", subtitle: "Connect to DubaiMall_Free")
                Divider().padding(.leading, 44)
                InfoRow(icon: "car.fill", title: "Parking Info", subtitle: "Rates and availability")
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var shoppingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shopping")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                InfoRow(icon: "heart.fill", title: "Wishlist", subtitle: "Items you've saved", showBadge: true, badgeCount: 8)
                Divider().padding(.leading, 44)
                InfoRow(icon: "bag.badge.plus", title: "Shopping List", subtitle: "Plan your visit")
                Divider().padding(.leading, 44)
                InfoRow(icon: "percent", title: "Offers & Deals", subtitle: "Current promotions", showBadge: true, badgeCount: 12)
                Divider().padding(.leading, 44)
                InfoRow(icon: "star.fill", title: "Loyalty Program", subtitle: "Earn points and rewards")
                Divider().padding(.leading, 44)
                InfoRow(icon: "receipt.fill", title: "Purchase History", subtitle: "Your recent transactions")
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var supportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Support")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                InfoRow(icon: "phone.fill", title: "Customer Service", subtitle: "Call +971 4 362 7500")
                Divider().padding(.leading, 44)
                InfoRow(icon: "questionmark.circle.fill", title: "FAQ", subtitle: "Common questions")
                Divider().padding(.leading, 44)
                InfoRow(icon: "bubble.left.and.bubble.right.fill", title: "Live Chat", subtitle: "Chat with our team")
                Divider().padding(.leading, 44)
                InfoRow(icon: "exclamationmark.triangle.fill", title: "Report Issue", subtitle: "Something not working?")
                Divider().padding(.leading, 44)
                InfoRow(icon: "star.bubble.fill", title: "Rate App", subtitle: "Share your feedback")
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                InfoRow(icon: "bell.fill", title: "Notifications", subtitle: "Manage alerts and updates") {
                    showingNotifications = true
                }
                Divider().padding(.leading, 44)
                InfoRow(icon: "globe", title: "Language", subtitle: "English") {
                    showingLanguage = true
                }
                Divider().padding(.leading, 44)
                InfoRow(icon: "moon.fill", title: "Dark Mode", subtitle: "System")
                Divider().padding(.leading, 44)
                InfoRow(icon: "location.fill", title: "Location Services", subtitle: "Always")
                Divider().padding(.leading, 44)
                InfoRow(icon: "lock.fill", title: "Privacy Settings", subtitle: "Manage your data")
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                InfoRow(icon: "doc.text.fill", title: "Terms of Service", subtitle: "Legal terms and conditions")
                Divider().padding(.leading, 44)
                InfoRow(icon: "hand.raised.fill", title: "Privacy Policy", subtitle: "How we protect your data")
                Divider().padding(.leading, 44)
                InfoRow(icon: "info.circle.fill", title: "App Version", subtitle: "1.2.3 (Build 456)")
                Divider().padding(.leading, 44)
                InfoRow(icon: "building.2.fill", title: "About Dubai Mall", subtitle: "Learn more about us")
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct ServiceCard: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var showBadge: Bool = false
    var badgeCount: Int = 0
    var action: (() -> Void)?
    
    var body: some View {
        Button(action: action ?? {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        if showBadge && badgeCount > 0 {
                            Text("\(badgeCount)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                        
                        Spacer()
                    }
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Sheets and Navigation
extension MoreView {
    private var profileSheet: some View {
        NavigationView {
            VStack {
                Text("Profile Settings")
                    .font(.title)
                    .padding()
                Spacer()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                showingProfile = false
            })
        }
    }
    
    private var notificationSheet: some View {
        NavigationView {
            List {
                Section("Push Notifications") {
                    Toggle("Store Offers", isOn: .constant(true))
                    Toggle("Event Reminders", isOn: .constant(true))
                    Toggle("Parking Alerts", isOn: .constant(false))
                }
                
                Section("Email Notifications") {
                    Toggle("Weekly Newsletter", isOn: .constant(true))
                    Toggle("Special Events", isOn: .constant(false))
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                showingNotifications = false
            })
        }
    }
}

// MARK: - Preview
struct DubaiMallMoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
