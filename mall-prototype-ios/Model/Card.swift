//
//  Card.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 22.5.25.
//

import Foundation
import SwiftUI

struct Card:Identifiable, Hashable{
    var id: String = UUID().uuidString
    var image: String
}

let cards: [Card] = [
    .init(image: "Pic 1"),
    .init(image: "Pic 2"),
    .init(image: "Pic 3"),
    .init(image: "Pic 4"),
]
