//
//  CommuteView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI

struct CommuteView: View {
    @State private var selectedTab = "CAR"
    
    let taxiData = [
        TaxiData(driverName: "Wizi", carModel: "", estimatedTime: 5, estimatedFare: 12.50, phoneNumber: "02 2777666"),
        TaxiData(driverName: "DE LUXE", carModel: "Honda Civic", estimatedTime: 8, estimatedFare: 15.75, phoneNumber: "0215187"),
        TaxiData(driverName: "Elite", carModel: "Nissan Altima", estimatedTime: 12, estimatedFare: 18.25, phoneNumber: "0215169"),
        TaxiData(driverName: "Vardar", carModel: "", estimatedTime: 5, estimatedFare: 12.50, phoneNumber: "0215195"),
        TaxiData(driverName: "Palas", carModel: "Honda Civic", estimatedTime: 8, estimatedFare: 15.75, phoneNumber: "0215166"),
        TaxiData(driverName: "24 Taxi", carModel: "Nissan Altima", estimatedTime: 12, estimatedFare: 18.25, phoneNumber: "072 315157")
    ]
    
    var parkingData: [ParkingSpot] = [
        .init(name: "Ground Floor", availableSlots: 271),
        .init(name: "Underground Floor", availableSlots: 148),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // FIXED STICKY HEADER AND TABS
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Spacer()
                        Text("COMMUTE")
                            .font(.headline)
                            .tracking(2)
                        
                        Spacer()
                        Image(systemName: "chevron.left")
                            .opacity(0)
                    }
                    .padding()
                    .background(Color.white)
                    
                    // Tabs
                    ZStack(alignment: .bottom) {
                        HStack(spacing: 0) {
                            ForEach(["CAR", "TAXI", "MORE"], id: \.self) { tab in
                                VStack(spacing: 8) {
                                    Text(tab)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(selectedTab == tab ? .black : .gray)
                                    
                                    Spacer()
                                        .frame(height: 2)
                                }
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedTab = tab
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                        .background(Color.white)
                        
                        // Bottom border line
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.gray.opacity(0.3))
                        
                        // Active tab indicator - positioned on the border line
                        HStack(spacing: 0) {
                            ForEach(Array(["CAR", "TAXI", "MORE"].enumerated()), id: \.offset) { index, tab in
                                Rectangle()
                                    .frame(height: 2)
                                    .foregroundColor(selectedTab == tab ? .black : .clear)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // SCROLLABLE CONTENT AREA
                ScrollView {
                    LazyVStack(spacing: 0, pinnedViews: []) {
                        Group {
                            switch selectedTab {
                            case "CAR":
                                carTabContent
                            case "TAXI":
                                taxiTabContent
                            case "MORE":
                                moreTabContent
                            default:
                                carTabContent
                            }
                        }
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                }
                .background(Color(.systemGroupedBackground))
            }
            .padding(.bottom, 50)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true) // Hide navigation bar if needed
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    // MARK: - Tab Content Views
    private var carTabContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("PARKING SPOTS")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Button("Refresh") {
                    // refresh logic
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            ForEach(parkingData) { spot in
                HStack {
                    Text(spot.name)
                        .font(.body)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(spot.availableSlots)")
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                    Text("Slots Available")
                        .foregroundColor(.gray)
                        .font(.caption)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
            }
            
            Divider()
                .padding(.vertical, 20)
                .padding(.horizontal)
            
            // Commute Cards
            VStack(spacing: 16) {
                NavigationLink(destination: FindMyCarView()) {
                    CommuteCardView(
                        imageName: "parking",
                        title: "Find My Car",
                        description: "Locate your parking spot"
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: PayParkingView()) {
                    CommuteCardView(
                        imageName: "payparking",
                        title: "Pay Parking",
                        description: "Pay parking fee directly from your phone."
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NavigationLink(destination: EVChargingView()) {
                    CommuteCardView(
                        imageName: "ev",
                        title: "EV Charging Station",
                        description: "Power up YouR Ride"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
    
    private var taxiTabContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("TAXI SERVICES")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .fontWeight(.medium)
                Spacer()
                Button("Refresh") {
                    // refresh taxi data
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            ForEach(taxiData) { taxi in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(taxi.driverName)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center) {
                            Text("\(taxi.estimatedTime) min")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Button(action: {
                        if let url = URL(string: "tel://\(taxi.phoneNumber)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(taxi.phoneNumber)
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                .padding(.horizontal)
            }
            
            Spacer(minLength: 32)
        }
    }
    
    private var moreTabContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading) {
                Text("MORE SERVICES")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            .padding(.top, 16)

            VStack(spacing: 16) {
                NavigationLink(destination: PublicTransitView()) {
                    CommuteCardView(
                        imageName: "bus",
                        title: "Public Transit",
                        description: "Bus schedules"
                    )
                }
                .buttonStyle(PlainButtonStyle())

                NavigationLink(destination: ScooterRentalView()) {
                    CommuteCardView(
                        imageName: "scooter",
                        title: "E-scooter",
                        description: "Rent a scooter for short trips"
                    )
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    let query = "Skopje East Gate Mall".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    if let url = URL(string: "http://maps.apple.com/?q=\(query)") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    CommuteCardView(
                        imageName: "map",
                        title: "Our Location",
                        description: "Navigate to our mall"
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}
