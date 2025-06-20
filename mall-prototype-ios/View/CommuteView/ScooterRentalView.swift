//
//  ScooterRentalView.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import SwiftUI

struct ScooterSpot: Identifiable {
    let id = UUID()
    let provider: String
    let locationName: String
    let distance: String // from user location
    let availableScooters: Int
}

struct ScooterRentalView: View {
    let scooterSpots = [
        ScooterSpot(provider: "Bolt", locationName: "City Park Entrance", distance: "850m", availableScooters: 3),
        ScooterSpot(provider: "Lime", locationName: "Makedonija Square", distance: "1.2km", availableScooters: 5),
        ScooterSpot(provider: "Tier", locationName: "Debar Maalo", distance: "900m", availableScooters: 2),
        ScooterSpot(provider: "Bolt", locationName: "Skopje Fortress", distance: "1.5km", availableScooters: 4),
        ScooterSpot(provider: "Tier", locationName: "Old Bazaar", distance: "1.8km", availableScooters: 1)
    ]
    
    var body: some View {
        NavigationView {
            List(scooterSpots) { spot in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(spot.provider)
                            .font(.headline)
                        Spacer()
                        Text("\(spot.availableScooters) available")
                            .foregroundColor(.green)
                            .font(.subheadline)
                    }
                    Text(spot.locationName)
                        .font(.subheadline)
                    Text("Distance: \(spot.distance)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 6)
            }
            .navigationTitle("E-Scooters Nearby")
        }
    }
}
