//
//  Untitled.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//

import Foundation

// Available learning durations
// المدد المتاحة للتعلم
enum LearningDuration: String, CaseIterable, Identifiable, Codable {
    case oneDay = "1 Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"

    // Provides a unique identifier for each duration
    // يوفر معرفًا مميزًا لكل مدة
    var id: String {
        rawValue
    }
}
