//
//  EVChargingView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct EVChargingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var batteryLevel = 45
    @State private var chargingTime = "1h 23m"
    @State private var isCharging = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Charging Status
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(Color(.systemGray5), lineWidth: 8)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(batteryLevel) / 100)
                            .stroke(batteryLevel < 20 ? .red : batteryLevel < 50 ? .orange : .green,
                                    style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 120, height: 120)
                            .rotationEffect(.degrees(-90))
                        
                        VStack {
                            Text("\(batteryLevel)%")
                                .font(.title)
                                .fontWeight(.bold)
                            Text("Battery")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(isCharging ? "Charging in Progress" : "Ready to Charge")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Station 4 - Level 2")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                
                // Charging Details
                if isCharging {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Charging Details")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DetailRow(icon: "clock", title: "Time Remaining", value: chargingTime)
                            DetailRow(icon: "bolt.fill", title: "Charging Rate", value: "7.2 kW")
                            DetailRow(icon: "dollarsign.circle", title: "Cost", value: "$0.25/kWh")
                            DetailRow(icon: "target", title: "Target", value: "80%")
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    if isCharging {
                        Button(action: {
                            isCharging.toggle()
                        }) {
                            HStack {
                                Image(systemName: "stop.fill")
                                Text("Stop Charging")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                        }
                    } else {
                        Button(action: {
                            isCharging.toggle()
                        }) {
                            HStack {
                                Image(systemName: "bolt.fill")
                                Text("Start Charging")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                    }
                    
                    ActionButton(
                        icon: "bell.fill",
                        title: "Set Notification",
                        subtitle: "Get notified when charging completes",
                        color: .orange
                    )
                }
                
                // Available Stations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Other Stations")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 8) {
                        ChargingStationRow(station: "Station 1", status: "Available", type: "Level 2")
                        ChargingStationRow(station: "Station 2", status: "Occupied", type: "Level 3")
                        ChargingStationRow(station: "Station 3", status: "Available", type: "Level 2")
                        ChargingStationRow(station: "Station 5", status: "Out of Order", type: "Level 3")
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
            }
            .padding()
            .padding(.vertical,50)
        }
        .navigationTitle("EV Charging")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .font(.title2)
                }
            }
        }
    }
}


struct ChargingStationRow: View {
    let station: String
    let status: String
    let type: String
    
    var statusColor: Color {
        switch status {
        case "Available": return .green
        case "Occupied": return .orange
        case "Out of Order": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(station)
                    .font(.headline)
                Text(type)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(status)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(statusColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.1))
                .cornerRadius(6)
        }
        .padding(.vertical, 4)
    }
}
