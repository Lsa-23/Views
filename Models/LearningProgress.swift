//
//  LearningProgress.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//

import Foundation

// Defines the status of each learning day
enum DayStatus: String, Codable {
    case learned
    case freezed
}

// Stores the user's learning progress
struct LearningProgress: Codable {

    var learningGoal: String

    var selectedDuration: LearningDuration

    var currentStreak: Int = 0

    var usedFreezes: Int = 0

    var lastActivityDate: Date? = nil

    var dailyRecords: [String: DayStatus] = [:]

    // Calculates the maximum number of freezes
    var freezeLimit: Int {
        switch selectedDuration {
        case .week:
            return 2

        case .month:
            return 8

        case .year:
            return 96
        }
    }

    // Calculates the remaining freezes
    var remainingFreezes: Int {
        max(0, freezeLimit - usedFreezes)
    }
}

