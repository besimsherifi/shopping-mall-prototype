//
//  ParkingSpot.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import Foundation

struct ParkingSpot: Identifiable {
    let id = UUID()
    let name: String
    let availableSlots: Int
}
