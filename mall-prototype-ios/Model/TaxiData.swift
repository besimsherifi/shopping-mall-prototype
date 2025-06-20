//
//  TaxiData.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 19.6.25.
//

import Foundation

struct TaxiData: Identifiable {
    let id = UUID()
    let driverName: String
    let carModel: String
    let estimatedTime: Int
    let estimatedFare: Double
    let phoneNumber: String
}
