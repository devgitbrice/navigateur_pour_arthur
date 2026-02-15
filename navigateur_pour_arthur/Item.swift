//
//  Item.swift
//  navigateur_pour_arthur
//
//  Created by BriceM4 on 15/02/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
