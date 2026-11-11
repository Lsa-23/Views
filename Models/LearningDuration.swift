//
//  Untitled.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//
import Foundation

// Available learning durations
enum LearningDuration: String, CaseIterable, Identifiable, Codable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var id: String {
        rawValue
    }
}
