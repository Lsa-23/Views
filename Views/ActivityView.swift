//
//  ActivityView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//

import SwiftUI

struct ActivityView: View {

    let learningGoal: String
    let selectedDuration: LearningDuration

    var body: some View {

        VStack(spacing: 20) {

            Text("Activity")
                .font(.largeTitle)
                .foregroundStyle(Color("PrimaryText"))

            Text("Your learning goal: \(learningGoal)")
                .foregroundStyle(Color("SecondaryText"))

            Text("Duration: \(selectedDuration.rawValue)")
                .foregroundStyle(Color("SecondaryText"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBG"))
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ActivityView(
        learningGoal: "Swift",
        selectedDuration: .week
    )
}

