//
//  OnboardingViewModel.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//
import Foundation
import Combine //احطها عشان مايطلع لي ايرورز 
// هنا حطينا كلاس مو ستركت لان نحتاج نسوي اكسس للمتغيرات عشان اعرف عنها وحطينا اوبزيرفل عشان لو تغيرت شي يعلم الباقي عن التغيرات
class OnboardingViewModel: ObservableObject {

    // هنا غيرنا بدل كلمه ستايت صارت ببلشد عشان هي المفروض تطلع لباقي الفيوز
    // Stores the user's learning goal
    @Published var learningGoal = ""

    // Stores the selected duration
    @Published var selectedDuration: LearningDuration? = nil

    // Checks if all required information is entered
    var canStartLearning: Bool {

        !learningGoal.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty && selectedDuration != nil
    }

    // Starts the learning process
    func startLearning() {

        guard canStartLearning else { return }

        print("Learning Goal: \(learningGoal)")
        print("Duration: \(selectedDuration?.rawValue ?? "")")
    }
}
