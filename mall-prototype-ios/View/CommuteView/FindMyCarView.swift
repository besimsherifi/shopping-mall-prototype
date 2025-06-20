//
//  FindMyCarView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct FindMyCarView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var parkingLevel = "Level 2"
    @State private var parkingZone = "Zone B"
    @State private var timeParked = "2h 15m ago"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Car Location Card
                VStack(spacing: 16) {
                    Image(systemName: "car.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Your car is parked at")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    VStack(spacing: 8) {
                        Text(parkingLevel)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(parkingZone)
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    
                    Text("Parked \(timeParked)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(24)
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
                
                // Action Buttons
                VStack(spacing: 12) {
                    ActionButton(
                        icon: "location.fill",
                        title: "Navigate to Car",
                        subtitle: "Get directions",
                        color: .blue
                    )
                    
                    ActionButton(
                        icon: "bell.fill",
                        title: "Set Reminder",
                        subtitle: "Don't forget where you parked",
                        color: .orange
                    )
                    
                    ActionButton(
                        icon: "camera.fill",
                        title: "View Parking Photo",
                        subtitle: "See your parking spot",
                        color: .green
                    )
                }
                
                // Parking Details
                VStack(alignment: .leading, spacing: 16) {
                    Text("Parking Details")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        DetailRow(icon: "clock", title: "Entry Time", value: "2:45 PM")
                        DetailRow(icon: "creditcard", title: "Rate", value: "$3.00/hour")
                        DetailRow(icon: "car.2", title: "Spot", value: "B-247")
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
        .navigationTitle("Find My Car")
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

struct ActionButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}
