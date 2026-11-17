//
//  EditLearningGoalView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//



import SwiftUI

struct EditLearningGoalView: View {

    // Observes the user's learning progress and goal updates
    // يراقب تقدم المستخدم والتغييرات على هدف التعلم
    @ObservedObject var viewModel: ActivityViewModel

    // Controls returning to the previous page
    // يتحكم بالرجوع إلى الصفحة السابقة
    @Environment(\.dismiss) private var dismiss

    // Stores the updated learning goal entered by the user
    // يخزن هدف التعلم الجديد الذي يدخله المستخدم
    @State private var learningGoal = ""

    // Stores the selected learning duration
    // يخزن مدة التعلم التي يختارها المستخدم
    @State private var selectedDuration: LearningDuration = .week

    // Controls displaying the update confirmation alert
    // يتحكم في إظهار رسالة تأكيد تحديث الهدف
    @State private var showUpdateAlert = false

    var body: some View {

        ZStack {

            // Main background color
            // لون خلفية الصفحة
            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 30) {

                // MARK: - Navigation Header
                // شريط التنقل العلوي
                HStack {

                    // Returns to the previous page
                    // يرجع إلى الصفحة السابقة
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

                    Text("Learning Goal")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    // Confirms the goal update
                    // يفتح رسالة تأكيد تحديث الهدف
                    Button {
                        showUpdateAlert = true
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
                // قسم تعديل هدف التعلم
                VStack(alignment: .leading, spacing: 15) {

                    Text("I want to learn")
                        .font(.system(size: 15))
                        .foregroundStyle(Color("PrimaryText"))

                    // Allows the user to edit the learning goal
                    // يسمح للمستخدم بتعديل هدف التعلم
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

                      
                        ForEach(LearningDuration.allCases) { duration in
                            
                            // Updates the selected duration when tapped
                            // يحدّث مدة التعلم عند الضغط على الخيار
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

                                    // Gives each duration button equal width
                                    // يجعل جميع أزرار المدة متساوية في العرض
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 58)

                                    // Adds one Liquid Glass effect with the selected duration color
                                    // يضيف تأثير زجاج واحد مع الحفاظ على لون الخيار المحدد
                                    .glassEffect(
                                        .regular.tint(
                                            selectedDuration == duration
                                            ? Color("AccentOrange")
                                            : Color("InactiveButton")
                                        ),
                                        in: Capsule()
                                    )
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

        // Loads the current goal information when the page appears
        // يحمل معلومات الهدف الحالي عند ظهور الصفحة
        .onAppear {
            learningGoal = viewModel.progress.learningGoal
            selectedDuration = viewModel.progress.selectedDuration
        }

        // Displays a confirmation alert before updating the goal
        // يعرض رسالة تأكيد قبل تحديث الهدف
        .alert("Update goal", isPresented: $showUpdateAlert) {

            Button("Dismiss", role: .cancel) { }

            Button("Update") {

                // Saves the updated goal and duration
                // يحفظ هدف التعلم والمدة الجديدة
                viewModel.updateGoal(
                    goal: learningGoal,
                    duration: selectedDuration
                )

                // Returns to the Activity page
                // يرجع إلى صفحة Activity
                dismiss()
            }

        } message: {
            Text("If you update now, your streak will start over.")
        }
    }
}

// MARK: - Preview
// معاينة صفحة تعديل هدف التعلم داخل Xcode
#Preview {
    NavigationStack {
        EditLearningGoalView(
            viewModel: ActivityViewModel(
                learningGoal: "Swift",
                duration: .week
            )
        )
    }
}
