//
//  SetNewGoalView.swift
//  Views
//
//  Created by Linah on 02/06/1448 AH.
//

import SwiftUI

struct SetNewGoalView: View {

    // Connects this page to the user's learning progress
    // يربط الصفحة ببيانات تقدم المستخدم
    @ObservedObject var viewModel: ActivityViewModel

    // Allows the user to return to the previous page
    // يسمح بالرجوع للصفحة السابقة
    @Environment(\.dismiss) private var dismiss

    // Stores the new learning goal entered by the user
    // يخزن هدف التعلم الجديد الذي يدخله المستخدم
    @State private var learningGoal = ""

    // Stores the duration selected for the new goal
    // يخزن المدة التي يختارها المستخدم للهدف الجديد
    @State private var selectedDuration: LearningDuration = .week

    // Controls showing the save confirmation alert
    // يتحكم في إظهار رسالة تأكيد حفظ الهدف
    @State private var showSaveAlert = false

    var body: some View {

        ZStack {

            // Main background color
            // لون خلفية الصفحة
            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 30) {

                // MARK: - Navigation Header
                // الجزء العلوي من الصفحة

                HStack {

                    // Back button
                    // زر الرجوع
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("InactiveButton"))
                            .clipShape(Circle())
                    }

                    Spacer()

                    // Page title
                    // عنوان الصفحة
                    Text("Set a new goal")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    // Save confirmation button
                    // زر تأكيد حفظ الهدف
                    Button {
                        showSaveAlert = true
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("AccentOrange"))
                            .clipShape(Circle())
                    }
                    .disabled(
                        learningGoal.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }

                // MARK: - Learning Goal
                // قسم إدخال هدف التعلم

                VStack(alignment: .leading, spacing: 15) {

                    Text("I want to learn")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("PrimaryText"))

                    TextField("Swift", text: $learningGoal)
                        .font(.system(size: 17))
                        .foregroundStyle(Color("PrimaryText"))
                        .tint(Color("AccentOrange"))

                    Rectangle()
                        .fill(Color("Divider"))
                        .frame(height: 1)
                }

                // MARK: - Duration Selection
                // قسم اختيار مدة التعلم

                VStack(alignment: .leading, spacing: 15) {

                    Text("I want to learn it in a")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("PrimaryText"))

                    HStack(spacing: 10) {

                        // Displays all available learning durations
                        // يعرض جميع مدد التعلم المتاحة
                        ForEach(LearningDuration.allCases) { duration in

                            Button {
                                selectedDuration = duration
                            } label: {

                                Text(duration.rawValue)
                                    .font(.system(size: 14))
                                    .foregroundStyle(
                                        selectedDuration == duration
                                        ? Color("PrimaryText")
                                        : Color("SecondaryText")
                                    )
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(
                                        selectedDuration == duration
                                        ? Color("AccentOrange")
                                        : Color("InactiveButton")
                                    )
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 15)
        }

        // Hides the default navigation back button
        // يخفي زر الرجوع الافتراضي
        .navigationBarBackButtonHidden(true)

        // Shows the save confirmation
        // يعرض رسالة تأكيد حفظ الهدف
        .alert("Set a new goal", isPresented: $showSaveAlert) {

            // Cancels saving and closes the alert
            // يلغي الحفظ ويغلق الرسالة
            Button("Dismiss", role: .cancel) { }

            // Saves the new learning goal
            // يحفظ هدف التعلم الجديد
            Button("Save") {

                viewModel.updateGoal(
                    goal: learningGoal.trimmingCharacters(in: .whitespaces),
                    duration: selectedDuration
                )

                // Returns to the Activity page
                // يرجع إلى صفحة Activity
                dismiss()
            }

        } message: {

            // Displays the goal entered by the user
            // يعرض الهدف الذي أدخله المستخدم
            Text("You will learn \(learningGoal.trimmingCharacters(in: .whitespaces)).")
        }
    }
}

// MARK: - Preview
// معاينة الصفحة داخل Xcode

#Preview {
    NavigationStack {
        SetNewGoalView(
            viewModel: ActivityViewModel(
                learningGoal: "Swift",
                duration: .week
            )
        )
    }
}

