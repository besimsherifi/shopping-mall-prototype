//
//  CommuteView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 3.6.25.
//

import SwiftUI

struct CommuteView: View {
    @State private var selectedTransport = "car"
    @State private var selectedParkingZone: ParkingZone?
    @State private var showingDirections = false
    
    let transportOptions = [
        TransportOption(id: "car", icon: "car.fill", label: "Drive", time: "25-45 min", cost: "AED 20-40", color: .blue),
        TransportOption(id: "metro", icon: "train.side.front.car", label: "Dubai Metro", time: "30-50 min", cost: "AED 7-15", color: .red),
        TransportOption(id: "bus", icon: "bus.fill", label: "RTA Bus", time: "40-60 min", cost: "AED 4-8", color: .orange),
        TransportOption(id: "taxi", icon: "location.fill", label: "Taxi/Careem", time: "20-40 min", cost: "AED 35-80", color: .green)
    ]
    
    let parkingZones = [
        ParkingZone(name: "Fashion Avenue Parking", level: "B2-B4", totalSpaces: 342, availableSpaces: 89, rate: "AED 20/day", status: .available, walkTime: "2 min walk to Fashion Avenue"),
        ParkingZone(name: "Cinema Parking", level: "Level 1", totalSpaces: 180, availableSpaces: 12, rate: "AED 20/day", status: .limited, walkTime: "1 min walk to Reel Cinemas"),
        ParkingZone(name: "Fountain Views Parking", level: "B1", totalSpaces: 520, availableSpaces: 156, rate: "AED 20/day", status: .available, walkTime: "3 min walk to Fountain"),
        ParkingZone(name: "Valet Parking", level: "Ground", totalSpaces: 50, availableSpaces: 8, rate: "AED 80/day", status: .premium, walkTime: "Direct access")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Transport Options
                    transportSection
                    
                    // Parking Information (shown only for car transport)
                    if selectedTransport == "car" {
                        parkingSection
                    }
                    
                    // Metro/Bus specific info
                    if selectedTransport == "metro" {
                        metroInfoSection
                    }
                    
                    if selectedTransport == "bus" {
                        busInfoSection
                    }
                    
                    // Quick Actions
                    quickActionsSection
                }
                .padding()
            }
            .navigationTitle("Commute & Parking")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.gold)
                    .font(.title2)
                Text("Shopping Mall")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Text("Open 10AM - 12AM")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.red)
                Text("Downtown Dubai, Burj Khalifa District")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var transportSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transportation Options")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(transportOptions, id: \.id) { option in
                    TransportCard(
                        option: option,
                        isSelected: selectedTransport == option.id
                    ) {
                        selectedTransport = option.id
                    }
                }
            }
        }
    }
    
    private var parkingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Parking Zones")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button("Find My Car") {
                    // Find car functionality
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            ForEach(parkingZones, id: \.name) { zone in
                ParkingZoneCard(zone: zone) {
                    selectedParkingZone = zone
                }
            }
        }
    }
    
    private var metroInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Metro Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                MetroInfoRow(icon: "train.side.front.car", title: "Burj Khalifa/Dubai Mall Station", subtitle: "Red Line - 5 min walk via air-conditioned bridge")
                MetroInfoRow(icon: "clock.fill", title: "Operating Hours", subtitle: "5:30 AM - 12:00 AM (Fri-Sat until 1:00 AM)")
                MetroInfoRow(icon: "creditcard.fill", title: "Nol Card Required", subtitle: "Available at station or use contactless payment")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var busInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bus Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                BusInfoRow(route: "Route 27", description: "Al Ghubaiba - Dubai Mall")
                BusInfoRow(route: "Route F13", description: "Ibn Battuta Mall - Dubai Mall")
                BusInfoRow(route: "Route 29", description: "Al Qusais - Dubai Mall")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var quickActionsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                QuickActionButton(icon: "map.fill", title: "Get Directions", color: .blue) {
                    showingDirections = true
                }
                
                QuickActionButton(icon: "phone.fill", title: "Call Mall", color: .green) {
                    // Call functionality
                }
            }
            
            HStack(spacing: 12) {
                QuickActionButton(icon: "car.2.fill", title: "Book Valet", color: .purple) {
                    // Valet booking
                }
                
                QuickActionButton(icon: "star.fill", title: "Save Route", color: .orange) {
                    // Save route
                }
            }
        }
    }
}

struct TransportCard: View {
    let option: TransportOption
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: option.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : option.color)
                
                Text(option.label)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text(option.time)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                
                Text(option.cost)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : option.color)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(isSelected ? option.color : Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ParkingZoneCard: View {
    let zone: ParkingZone
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(zone.name)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    StatusBadge(status: zone.status)
                }
                
                HStack {
                    Image(systemName: "building.fill")
                        .foregroundColor(.secondary)
                    Text(zone.level)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(zone.availableSpaces)/\(zone.totalSpaces) spaces")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text(zone.rate)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text(zone.walkTime)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Availability bar
                ProgressView(value: Double(zone.availableSpaces), total: Double(zone.totalSpaces))
                    .progressViewStyle(LinearProgressViewStyle(tint: zone.status.color))
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatusBadge: View {
    let status: ParkingStatus
    
    var body: some View {
        Text(status.rawValue.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
    }
}

struct MetroInfoRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.red)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct BusInfoRow: View {
    let route: String
    let description: String
    
    var body: some View {
        HStack {
            Text(route)
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .foregroundColor(.orange)
                .cornerRadius(6)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct QuickActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models
struct TransportOption {
    let id: String
    let icon: String
    let label: String
    let time: String
    let cost: String
    let color: Color
}

struct ParkingZone {
    let name: String
    let level: String
    let totalSpaces: Int
    let availableSpaces: Int
    let rate: String
    let status: ParkingStatus
    let walkTime: String
}

enum ParkingStatus: String, CaseIterable {
    case available = "available"
    case limited = "limited"
    case full = "full"
    case premium = "premium"
    
    var color: Color {
        switch self {
        case .available: return .green
        case .limited: return .orange
        case .full: return .red
        case .premium: return .purple
        }
    }
}

// MARK: - Color Extension
extension Color {
    static let gold = Color(red: 1.0, green: 0.84, blue: 0.0)
}

// MARK: - Preview
struct DubaiMallCommuteView_Previews: PreviewProvider {
    static var previews: some View {
        CommuteView()
    }
}
