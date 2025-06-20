//
//  PublicTransitView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct BusRoute: Identifiable {
    let id = UUID()
    let lineNumber: String
    let departureTime: String
    let arrivalTime: String
    let from: String
}

struct PublicTransitView: View {
    let busRoutesToEastGate = [
        BusRoute(lineNumber: "5", departureTime: "14:15", arrivalTime: "14:35", from: "City Center"),
        BusRoute(lineNumber: "2A", departureTime: "14:30", arrivalTime: "14:55", from: "Bit Pazar"),
        BusRoute(lineNumber: "15", departureTime: "14:50", arrivalTime: "15:20", from: "Aerodrom"),
        BusRoute(lineNumber: "22", departureTime: "15:00", arrivalTime: "15:25", from: "Gjorche Petrov"),
        BusRoute(lineNumber: "57", departureTime: "15:20", arrivalTime: "15:45", from: "Novo Lisiche")
    ]
    
    var body: some View {
        NavigationView {
            List(busRoutesToEastGate) { route in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Line \(route.lineNumber)")
                            .font(.headline)
                        Spacer()
                        Text("\(route.departureTime) → \(route.arrivalTime)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Text("From: \(route.from)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("To East Gate Mall")
        }
    }
}
