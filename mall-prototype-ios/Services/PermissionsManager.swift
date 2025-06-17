//
//  PermissionsManager.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import Foundation
import CoreLocation
import CoreBluetooth
import Combine
import UIKit

/// Manages permission requests and status for location and Bluetooth services
class PermissionsManager: NSObject, ObservableObject {
    static let shared = PermissionsManager()
    
    @Published var locationPermissionStatus: CLAuthorizationStatus = .notDetermined
    @Published var bluetoothPermissionStatus: CBManagerAuthorization = .notDetermined
    @Published var hasRequestedPermissions = false
    
    private var locationManager = CLLocationManager()
    private var bluetoothManager: CBCentralManager?
    
    private override init() {
        super.init()
        setupLocationManager()
        setupBluetoothManager()
        loadPermissionState()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationPermissionStatus = locationManager.authorizationStatus
    }
    
    private func setupBluetoothManager() {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    private func loadPermissionState() {
        hasRequestedPermissions = UserDefaults.standard.bool(forKey: "hasRequestedPermissions")
    }
    
    private func savePermissionState() {
        UserDefaults.standard.set(hasRequestedPermissions, forKey: "hasRequestedPermissions")
    }
    
    /// Check if all required permissions are granted
    var allPermissionsGranted: Bool {
        return locationPermissionGranted && bluetoothPermissionGranted
    }
    
    /// Check if location permission is granted
    var locationPermissionGranted: Bool {
        return locationPermissionStatus == .authorizedWhenInUse || locationPermissionStatus == .authorizedAlways
    }
    
    /// Check if Bluetooth permission is granted
    var bluetoothPermissionGranted: Bool {
        return bluetoothPermissionStatus == .allowedAlways
    }
    
    /// Request location permission
    func requestLocationPermission() {
        guard locationPermissionStatus == .notDetermined else { return }
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Request "always" location permission (needed for background positioning)
    func requestAlwaysLocationPermission() {
        guard locationPermissionGranted else {
            requestLocationPermission()
            return
        }
        locationManager.requestAlwaysAuthorization()
    }
    
    /// Request Bluetooth permission (handled automatically by CBCentralManager)
    func requestBluetoothPermission() {
        // Bluetooth permission is automatically requested when CBCentralManager is initialized
        // We just need to update our status when it changes
    }
    
    /// Mark that we've shown the permission request flow
    func markPermissionsRequested() {
        hasRequestedPermissions = true
        savePermissionState()
    }
    
    /// Open app settings
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    /// Check current permission statuses
    func refreshPermissionStatuses() {
        locationPermissionStatus = locationManager.authorizationStatus
        bluetoothPermissionStatus = CBCentralManager().authorization
    }
}

// MARK: - CLLocationManagerDelegate
extension PermissionsManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.locationPermissionStatus = manager.authorizationStatus
        }
    }
}

// MARK: - CBCentralManagerDelegate
extension PermissionsManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        DispatchQueue.main.async {
            self.bluetoothPermissionStatus = central.authorization
        }
    }
}
