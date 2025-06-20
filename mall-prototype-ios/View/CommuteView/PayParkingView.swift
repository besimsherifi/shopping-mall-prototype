//
//  PayParkingView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct PayParkingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDuration = 2
    @State private var totalAmount = 6.0
    @State private var showingScanner = false
    @State private var hasScannedTicket = true // Set to false initially in real app
    @State private var ticketNumber = "MPT-2024-456789"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Scan Ticket Card (if not scanned)
                if !hasScannedTicket {
                    VStack(spacing: 16) {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Scan Your Parking Ticket")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Scan your parking ticket to view current charges and extend your parking time")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            showingScanner = true
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Scan Ticket")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                    .padding(24)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 2)
                } else {
                    // Current Parking Info (if ticket scanned)
                    VStack(spacing: 16) {
                        Image(systemName: "parkingsign.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Zone B - Spot 247")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Currently parked for 2h 15m")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Ticket: \(ticketNumber)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray5))
                            .cornerRadius(6)
                        
                        // Rescan option
                        Button(action: {
                            showingScanner = true
                        }) {
                            HStack {
                                Image(systemName: "qrcode")
                                Text("Scan Different Ticket")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                
                // Extend Parking Duration (only show if ticket is scanned)
                if hasScannedTicket {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Extend Parking")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            DurationOption(duration: "1 hour", price: "$3.00", isSelected: selectedDuration == 1) {
                                selectedDuration = 1
                                totalAmount = 3.0
                            }
                            
                            DurationOption(duration: "2 hours", price: "$6.00", isSelected: selectedDuration == 2) {
                                selectedDuration = 2
                                totalAmount = 6.0
                            }
                            
                            DurationOption(duration: "4 hours", price: "$12.00", isSelected: selectedDuration == 4) {
                                selectedDuration = 4
                                totalAmount = 12.0
                            }
                            
                            DurationOption(duration: "All day", price: "$20.00", isSelected: selectedDuration == 8) {
                                selectedDuration = 8
                                totalAmount = 20.0
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
                }
                
                // Payment Summary (only show if ticket is scanned)
                if hasScannedTicket {
                    VStack(spacing: 16) {
                        HStack {
                            Text("Total Amount")
                                .font(.headline)
                            Spacer()
                            Text("$\(String(format: "%.2f", totalAmount))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            // Handle payment
                        }) {
                            Text("Pay Now")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                // Payment Methods (only show if ticket is scanned)
                if hasScannedTicket {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Payment Methods")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        PaymentMethodRow(icon: "creditcard.fill", title: "Credit Card", subtitle: "•••• 4532")
                        PaymentMethodRow(icon: "applelogo", title: "Apple Pay", subtitle: "Touch ID or Face ID")
                        PaymentMethodRow(icon: "dollarsign.circle.fill", title: "Mall Wallet", subtitle: "$45.60 available")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 1)
                }
            }
            .padding()
            .padding(.vertical,40)
        }
        .navigationTitle("Pay Parking")
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
        .sheet(isPresented: $showingScanner) {
            TicketScannerView(hasScannedTicket: $hasScannedTicket)
        }
    }
}

struct DurationOption: View {
    let duration: String
    let price: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(duration)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("Extend parking time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(price)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.blue)
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}


struct PaymentMethodRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        }
        .padding(.vertical, 8)
    }
}


struct TicketScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var hasScannedTicket: Bool
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera background simulation
                Rectangle()
                    .fill(Color.black)
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    // Scanning frame
                    ZStack {
                        Rectangle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 250, height: 250)
                        
                        // Corner brackets
                        VStack {
                            HStack {
                                CornerBracket(topLeading: true)
                                Spacer()
                                CornerBracket(topTrailing: true)
                            }
                            Spacer()
                            HStack {
                                CornerBracket(bottomLeading: true)
                                Spacer()
                                CornerBracket(bottomTrailing: true)
                            }
                        }
                        .frame(width: 250, height: 250)
                        
                        // Scanning line animation
                        Rectangle()
                            .fill(Color.blue)
                            .frame(height: 2)
                            .offset(y: isScanning ? -100 : 100)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isScanning)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Scan Parking Ticket")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("Position the QR code within the frame")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Simulate successful scan after 2 seconds
                    Button(action: {
                        // Simulate scan success
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            hasScannedTicket = true
                            dismiss()
                        }
                    }) {
                        Text("Simulate Scan Success")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.bottom, 50)
                }
                .padding()
            }
            .navigationTitle("Scan Ticket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            isScanning = true
        }
    }
}


struct CornerBracket: View {
    let topLeading: Bool
    let topTrailing: Bool
    let bottomLeading: Bool
    let bottomTrailing: Bool
    
    init(topLeading: Bool = false, topTrailing: Bool = false, bottomLeading: Bool = false, bottomTrailing: Bool = false) {
        self.topLeading = topLeading
        self.topTrailing = topTrailing
        self.bottomLeading = bottomLeading
        self.bottomTrailing = bottomTrailing
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if topLeading || topTrailing {
                HStack(spacing: 0) {
                    if topLeading {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 3)
                            HStack {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 3, height: 20)
                                Spacer()
                            }
                        }
                    }
                    if topTrailing {
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 3)
                            HStack {
                                Spacer()
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 3, height: 20)
                            }
                        }
                    }
                }
            }
            
            if bottomLeading || bottomTrailing {
                HStack(spacing: 0) {
                    if bottomLeading {
                        VStack(spacing: 0) {
                            HStack {
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 3, height: 20)
                                Spacer()
                            }
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 3)
                        }
                    }
                    if bottomTrailing {
                        VStack(spacing: 0) {
                            HStack {
                                Spacer()
                                Rectangle()
                                    .fill(Color.blue)
                                    .frame(width: 3, height: 20)
                            }
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 20, height: 3)
                        }
                    }
                }
            }
        }
        .frame(width: 20, height: 20)
    }
}
