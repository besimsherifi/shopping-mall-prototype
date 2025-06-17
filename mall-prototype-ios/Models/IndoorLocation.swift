//
//  IndoorLocation.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 17/06/2025.
//

import Foundation
import CoreLocation

/// Represents a physical location with indoor navigation capabilities
struct IndoorLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let siteIdKey: String // Reference to the key in APIKeys.SiteIDs
    
    /// Returns the actual Site ID from APIKeys using the stored key
    var siteId: UInt32 {
        switch siteIdKey {
        case "shortcutHQ":
            return APIKeys.SiteIDs.shortcutHQ
        case "remaEnsjo":
            return APIKeys.SiteIDs.remaEnsjo
        case "securitasMalmo":
            return APIKeys.SiteIDs.securitasMalmo
        default:
            return 0 // Invalid ID
        }
    }
    
    // Known indoor locations
    static let availableLocations = [
        IndoorLocation(
            name: "Shortcut HQ",
            coordinate: CLLocationCoordinate2D(latitude: 59.913132, longitude: 10.736364),
            siteIdKey: "shortcutHQ"
        ),
        IndoorLocation(
            name: "REMA 1000 Ensjø",
			coordinate: CLLocationCoordinate2D(latitude: 59.91506, longitude: 10.78766),
            siteIdKey: "remaEnsjo"
        ),
        IndoorLocation(
            name: "Securitas Malmö",
            coordinate: CLLocationCoordinate2D(latitude: 55.573522, longitude: 13.058097),
            siteIdKey: "securitasMalmo"
        )
    ]
}
