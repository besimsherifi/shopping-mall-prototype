//
//  NavigateView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI
import MapKit

struct NavigateView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 25.1968, longitude: 55.2744), // Dubai Mall coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) // Zoomed in for building level
    )
    
    @State private var selectedFloor = 0
    @State private var searchText = ""
    @State private var showingDirections = false
    
    private let floors = ["Ground Floor", "Level 1", "Level 2", "Level 3"]
    private let buildingAnnotations = [
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1970, longitude: 55.2742), name: "Main Entrance", type: .entrance),
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1966, longitude: 55.2746), name: "Food Court", type: .dining),
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1972, longitude: 55.2748), name: "Restrooms", type: .restroom),
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1964, longitude: 55.2740), name: "Apple Store", type: .shop),
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1968, longitude: 55.2750), name: "Parking Entrance", type: .parking),
        BuildingLocation(coordinate: CLLocationCoordinate2D(latitude: 25.1975, longitude: 55.2745), name: "Emergency Exit", type: .emergency)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Floor Selector
                floorSelector
                
                // Map View
                mapView
                
                // Quick Actions
                quickActionsBar
            }
            .navigationTitle("Navigate")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("My Location") {
                        // Center map on user location
                        centerOnUserLocation()
                    }
                    .font(.caption)
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search stores, restaurants, facilities...", text: $searchText)
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
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    private var floorSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<floors.count, id: \.self) { index in
                    Button(floors[index]) {
                        selectedFloor = index
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(selectedFloor == index ? Color.blue : Color(.systemGray5))
                    .foregroundColor(selectedFloor == index ? .white : .primary)
                    .cornerRadius(20)
                    .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }
    
    private var mapView: some View {
        Map(coordinateRegion: $region, annotationItems: buildingAnnotations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    ZStack {
                        Circle()
                            .fill(colorForLocationType(location.type))
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: iconForLocationType(location.type))
                            .foregroundColor(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    
                    Text(location.name)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(4)
                        .shadow(radius: 2)
                }
                .onTapGesture {
                    showDirections(to: location)
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var quickActionsBar: some View {
        HStack(spacing: 20) {
            NavigationActionButton(
                icon: "figure.walk",
                title: "Directions",
                color: .blue
            ) {
                showingDirections.toggle()
            }
            
            NavigationActionButton(
                icon: "car.fill",
                title: "Parking",
                color: .green
            ) {
                findParking()
            }
            
            NavigationActionButton(
                icon: "toilet.fill",
                title: "Restroom",
                color: .orange
            ) {
                findRestroom()
            }
            
            NavigationActionButton(
                icon: "info.circle.fill",
                title: "Info",
                color: .purple
            ) {
                showBuildingInfo()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
    
    private func colorForLocationType(_ type: LocationType) -> Color {
        switch type {
        case .entrance: return .blue
        case .shop: return .purple
        case .dining: return .orange
        case .restroom: return .green
        case .parking: return .gray
        case .emergency: return .red
        }
    }
    
    private func iconForLocationType(_ type: LocationType) -> String {
        switch type {
        case .entrance: return "door.left.hand.open"
        case .shop: return "bag.fill"
        case .dining: return "fork.knife"
        case .restroom: return "toilet.fill"
        case .parking: return "car.fill"
        case .emergency: return "exclamationmark.triangle.fill"
        }
    }
    
    private func centerOnUserLocation() {
        // Simulate centering on user location
        withAnimation(.easeInOut(duration: 0.5)) {
            region.center = CLLocationCoordinate2D(latitude: 25.1968, longitude: 55.2744)
        }
    }
    
    private func showDirections(to location: BuildingLocation) {
        print("Showing directions to: \(location.name)")
        showingDirections = true
    }
    
    private func findParking() {
        // Focus on parking areas
        if let parkingLocation = buildingAnnotations.first(where: { $0.type == .parking }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                region.center = parkingLocation.coordinate
            }
        }
    }
    
    private func findRestroom() {
        // Focus on restroom locations
        if let restroomLocation = buildingAnnotations.first(where: { $0.type == .restroom }) {
            withAnimation(.easeInOut(duration: 0.5)) {
                region.center = restroomLocation.coordinate
            }
        }
    }
    
    private func showBuildingInfo() {
        print("Showing building information")
    }
}

struct NavigationActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct BuildingLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let type: LocationType
}

enum LocationType {
    case entrance, shop, dining, restroom, parking, emergency
}

// MARK: - Integration with your existing code

// Replace the case 1 in your MainView with:
// case 1: NavigateView()

struct MainView_Updated: View {
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
                case 1: NavigateView() // Updated this line
                case 2: Text("Explore")
                case 3: Text("Commute")
                case 4: Text("More")
                default: HomeView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())

            CustomTabBar(selectedIndex: $selectedTab, items: tabs)
        }
    }
}
