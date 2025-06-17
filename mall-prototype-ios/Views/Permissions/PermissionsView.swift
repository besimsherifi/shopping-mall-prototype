//
//  PermissionsView.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import SwiftUI
import CoreLocation

struct PermissionsView: View {
    @StateObject private var permissionsManager = PermissionsManager.shared
    @State private var currentStep: PermissionStep = .welcome
    @State private var showingSettings = false
    
    let onComplete: () -> Void
    
    enum PermissionStep: CaseIterable {
        case welcome
        case location
        case bluetooth
        case complete
        
        var title: String {
            switch self {
            case .welcome:
                return "Welcome to Mall Navigation"
            case .location:
                return "Location Access"
            case .bluetooth:
                return "Bluetooth Access"
            case .complete:
                return "You're All Set!"
            }
        }
        
        var description: String {
            switch self {
            case .welcome:
                return "To provide you with precise indoor navigation, we need access to your location and Bluetooth."
            case .location:
                return "We use your location to show your position on the map and provide turn-by-turn navigation inside the mall."
            case .bluetooth:
                return "Bluetooth helps us provide accurate indoor positioning using beacon technology for precise navigation."
            case .complete:
                return "Great! You can now use indoor navigation to find stores, restaurants, and facilities in the mall."
            }
        }
        
        var icon: String {
            switch self {
            case .welcome:
                return "location.north.line.fill"
            case .location:
                return "location.fill"
            case .bluetooth:
                return "bluetooth"
            case .complete:
                return "checkmark.circle.fill"
            }
        }
        
        var iconColor: Color {
            switch self {
            case .welcome:
                return .blue
            case .location:
                return .green
            case .bluetooth:
                return .blue
            case .complete:
                return .green
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Icon
            Image(systemName: currentStep.icon)
                .font(.system(size: 80))
                .foregroundColor(currentStep.iconColor)
                .animation(.spring(response: 0.5), value: currentStep)
            
            // Title and Description
            VStack(spacing: 16) {
                Text(currentStep.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(currentStep.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                actionButton
                
                if currentStep == .location || currentStep == .bluetooth {
                    if needsSettingsButton {
                        Button("Open Settings") {
                            permissionsManager.openAppSettings()
                            showingSettings = true
                        }
                        .font(.headline)
                        .foregroundColor(.blue)
                    }
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onReceive(permissionsManager.$locationPermissionStatus) { _ in
            checkPermissionsAndAdvance()
        }
        .onReceive(permissionsManager.$bluetoothPermissionStatus) { _ in
            checkPermissionsAndAdvance()
        }
        .onAppear {
            permissionsManager.refreshPermissionStatuses()
        }
        .onChange(of: showingSettings) { _, isShowing in
            if !isShowing {
                permissionsManager.refreshPermissionStatuses()
            }
        }
    }
    
    @ViewBuilder
    private var actionButton: some View {
        Button(action: handleButtonTap) {
            Text(buttonText)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(buttonColor)
                .cornerRadius(12)
        }
        .disabled(isButtonDisabled)
    }
    
    private var buttonText: String {
        switch currentStep {
        case .welcome:
            return "Get Started"
        case .location:
            if permissionsManager.locationPermissionGranted {
                return "Continue"
            } else if permissionsManager.locationPermissionStatus == .denied {
                return "Permission Denied"
            } else {
                return "Allow Location Access"
            }
        case .bluetooth:
            if permissionsManager.bluetoothPermissionGranted {
                return "Continue"
            } else if permissionsManager.bluetoothPermissionStatus == .denied {
                return "Permission Denied"
            } else {
                return "Allow Bluetooth Access"
            }
        case .complete:
            return "Start Shopping"
        }
    }
    
    private var buttonColor: Color {
        if isButtonDisabled {
            return .gray
        }
        
        switch currentStep {
        case .welcome, .complete:
            return .blue
        case .location:
            return permissionsManager.locationPermissionGranted ? .green : .blue
        case .bluetooth:
            return permissionsManager.bluetoothPermissionGranted ? .green : .blue
        }
    }
    
    private var isButtonDisabled: Bool {
        switch currentStep {
        case .location:
            return permissionsManager.locationPermissionStatus == .denied
        case .bluetooth:
            return permissionsManager.bluetoothPermissionStatus == .denied
        default:
            return false
        }
    }
    
    private var needsSettingsButton: Bool {
        switch currentStep {
        case .location:
            return permissionsManager.locationPermissionStatus == .denied
        case .bluetooth:
            return permissionsManager.bluetoothPermissionStatus == .denied
        default:
            return false
        }
    }
    
    private func handleButtonTap() {
        switch currentStep {
        case .welcome:
            currentStep = .location
            
        case .location:
            if permissionsManager.locationPermissionGranted {
                currentStep = .bluetooth
            } else {
                permissionsManager.requestLocationPermission()
            }
            
        case .bluetooth:
            if permissionsManager.bluetoothPermissionGranted {
                currentStep = .complete
            } else {
                permissionsManager.requestBluetoothPermission()
            }
            
        case .complete:
            permissionsManager.markPermissionsRequested()
            onComplete()
        }
    }
    
    private func checkPermissionsAndAdvance() {
        switch currentStep {
        case .location:
            if permissionsManager.locationPermissionGranted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) {
                        currentStep = .bluetooth
                    }
                }
            }
            
        case .bluetooth:
            if permissionsManager.bluetoothPermissionGranted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) {
                        currentStep = .complete
                    }
                }
            }
            
        default:
            break
        }
    }
}

struct PermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView {
            print("Permissions completed")
        }
    }
}
