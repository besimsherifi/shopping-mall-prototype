//
//  NavigateView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI
import MapKit
import Unicorn
import CoreLocation

struct NavigateView: View {
    @State private var region = MKCoordinateRegion(
		center: CLLocationCoordinate2D(latitude: 59.91321, longitude: 10.73614), // REMA 1000 Ensjø coordinates
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002) // Zoomed in for building level
    )
    
    @State private var searchText = ""
    @State private var showingIndoorNav = false
    @State private var isIndoorMode = false
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var currentLocation: CLLocationCoordinate2D?
    @State private var locationManager = CLLocationManager()
    @State private var locationDelegate: LocationDelegate?
    @State private var isNearTargetLocation = false
    
    // Target location for indoor navigation
    private let targetLocation = CLLocationCoordinate2D(latitude: 59.91325, longitude: 10.73609)
    
    // REMA location (default for this demo)
    private let remaLocation = IndoorLocation.availableLocations.first { $0.siteIdKey == "shortcutHQ" }!
    
    var body: some View {
        NavigationView {
            ZStack {
                // Map View
                mapView
                
                // Indoor Navigation Controls
                VStack {
                    // Search Bar
                    searchBar
                    
                    Spacer()
                    
                    // Indoor Navigation Toggle - Only show when near target location
                    if isNearTargetLocation {
                        indoorNavToggle
                    }
                }
            }
            .navigationTitle("Navigate")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                // Center map on REMA location
                centerOnRemaLocation()
                // Start location tracking
                startLocationTracking()
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search in mall...", text: $searchText)
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
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .shadow(color: .black.opacity(0.1), radius: 5)
    }
    
    
    private var mapView: some View {
        ZStack {
            IndoorMapViewRepresentable(
                region: $region,
                isIndoorMode: $isIndoorMode,
                userLocation: $userLocation
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            
        }
    }
    
    
    private var indoorNavToggle: some View {
        VStack(spacing: 16) {
            if !isIndoorMode {
                // Indoor Navigation Prompt
                VStack(spacing: 12) {
                    Image(systemName: "location.north.line.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Indoor Navigation Available")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text("Switch to indoor navigation for precise positioning inside Shortcut Norway HQ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button("Start Indoor Navigation") {
                        startIndoorNavigation()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.headline)
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 10)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            } else {
                // Indoor Navigation Active
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.green)
                        Text("Indoor Navigation Active")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    Text("Shortcut Norway HQ")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button("Exit Indoor Mode") {
                        stopIndoorNavigation()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(8)
                    .font(.subheadline)
                }
                .padding(16)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .animation(.spring(response: 0.3), value: isIndoorMode)
    }
    
    private func centerOnRemaLocation() {
        withAnimation(.easeInOut(duration: 1.0)) {
            region.center = remaLocation.coordinate
        }
    }
    
    private func startLocationTracking() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("❌ Location services are disabled on this device")
            return
        }
        
        locationDelegate = LocationDelegate(onLocationUpdate: { location in
            DispatchQueue.main.async {
                self.currentLocation = location.coordinate
                print("📍 Location updated: \(location.coordinate)")
                self.checkProximityToTarget()
            }
        })
        
        locationManager.delegate = locationDelegate
        
        print("🔐 Requesting location permission...")
        locationManager.requestWhenInUseAuthorization()
        
        print("🎯 Starting location updates...")
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func checkProximityToTarget() {
        guard let currentLocation = currentLocation else { 
            print("❌ No current location available for proximity check")
            return 
        }
        
        let distance = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            .distance(from: CLLocation(latitude: targetLocation.latitude, longitude: targetLocation.longitude))
        
        print("📍 Current location: \(currentLocation.latitude), \(currentLocation.longitude)")
        print("🎯 Target location: \(targetLocation.latitude), \(targetLocation.longitude)")
        print("📏 Distance to target: \(distance) meters")
        
        // Show indoor navigation button if within 20 meters of target location
        isNearTargetLocation = distance <= 20
        print("🔘 Indoor nav button visible: \(isNearTargetLocation)")
    }
    
    private func startIndoorNavigation() {
        print("Starting indoor navigation for REMA 1000 Ensjø")
        
        // Create service config with site ID
        let config = Unicorn.ServiceConfig(siteId: remaLocation.siteId)
        
        // Register callbacks for position updates
        Unicorn.PositioningService.registerPositionCallback { position in
            DispatchQueue.main.async {
                self.userLocation = position.coordinate
                print("Indoor position updated: \(position.coordinate)")
            }
        }
        
        // Register site callback
        Unicorn.PositioningService.registerSiteCallback { site in
            DispatchQueue.main.async {
                if let site = site {
                    print("Site loaded: \(site.name)")
                    self.isIndoorMode = true
                }
            }
        }
        
        // Register state callback to handle errors
        Unicorn.PositioningService.registerStateCallback { state, error in
            DispatchQueue.main.async {
                print("Positioning state: \(state)")
                if let error = error {
                    print("Positioning error: \(error)")
                }
            }
        }
        
        // Load and start positioning
        Unicorn.PositioningService.load(config)
        let result = Unicorn.PositioningService.start(config)
        
        switch result {
        case .ok:
            print("Unicorn positioning started successfully")
        case .missingConfiguration(let key):
            print("Missing configuration: \(key)")
        case .unauthorized:
            print("Unauthorized to use positioning service")
        case .error(let message):
            print("Failed to start positioning: \(message)")
        }
    }
    
    private func stopIndoorNavigation() {
        print("Stopping indoor navigation")
        
        // Stop and unload positioning service
        Unicorn.PositioningService.stop(unload: true)
        
        // Reset local state
        isIndoorMode = false
        userLocation = nil
        print("Indoor navigation stopped successfully")
    }
}


class LocationDelegate: NSObject, CLLocationManagerDelegate {
    var onLocationUpdate: (CLLocation) -> Void
    
    init(onLocationUpdate: @escaping (CLLocation) -> Void) {
        self.onLocationUpdate = onLocationUpdate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("✅ Location received: \(location.coordinate)")
        onLocationUpdate(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("🔐 Location authorization changed: \(status.rawValue)")
        switch status {
        case .notDetermined:
            print("📍 Location permission not determined")
        case .denied:
            print("❌ Location permission denied")
        case .restricted:
            print("🚫 Location permission restricted")
        case .authorizedWhenInUse:
            print("✅ Location permission granted (when in use)")
            manager.startUpdatingLocation()
        case .authorizedAlways:
            print("✅ Location permission granted (always)")
            manager.startUpdatingLocation()
        @unknown default:
            print("❓ Unknown location permission status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Location manager failed with error: \(error.localizedDescription)")
    }
}
