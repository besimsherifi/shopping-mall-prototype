//
//  QuickAccessItem.swift
//  mall-prototype-ios
//
//  Created by Vullnet Azizi on 16.6.25.
//

import SwiftUI

struct QuickAccessItem: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let backgroundColor: Color
}