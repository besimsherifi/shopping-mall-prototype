//
//  HomeView.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI
import AVKit

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
                                        imageName: "aquarium_bg",
                                        title: "DUBAI AQUARIUM & UNDERWA...",
                                        mainText: "Flash Sale Alert:",
                                        subText: "Summer Fun Pass!",
                                        dateRange: "19 MAY - 4 JUN"
                                    )
                                    
                                    // House of Hype Card
                                    OfferCard(
                                        imageName: "hype_bg",
                                        title: "HOUSE OF HYPE",
                                        mainText: "Squad Pass at Hou",
                                        subText: "Hype!",
                                        dateRange: "1 MAY - 31 DEC"
                                    )
                                    
                                    OfferCard(
                                        imageName: "hype_bg",
                                        title: "HOUSE OF MUSIC",
                                        mainText: "The Summer hits are here",
                                        subText: "Hype!",
                                        dateRange: "1 June - 31 July"
                                    )
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
        guard let videoURL = Bundle.main.url(forResource: "video1", withExtension: "mp4") else {
            print("Video file not found")
            return
        }
        
        player = AVPlayer(url: videoURL)
        player.play()
    }
}