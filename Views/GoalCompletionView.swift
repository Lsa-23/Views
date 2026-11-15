//
//  GoalCompletionView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//






import SwiftUI

struct GoalCompletionView: View {

    // Stores whether the user completed the learning goal
    // يحدد هل المستخدم أكمل هدف التعلم أم لا
    let goalAchieved: Bool

    // Handles navigation to the new goal page
    // ينفذ الانتقال إلى صفحة الهدف الجديد
    let onSetGoal: () -> Void

    var body: some View {

        VStack(spacing: 0) {

            Spacer()

            // MARK: - Result Content
            // محتوى نتيجة الهدف

            VStack(spacing: 10) {

                // Displays the result icon
                // يعرض أيقونة نتيجة الهدف
                Image(
                    systemName: goalAchieved
                    ? "hands.and.sparkles"
                    : "xmark.seal.fill"
                )
                .font(.system(size: 30))
                .foregroundStyle(
                    goalAchieved
                    ? Color.yellow
                    : Color("AccentOrange")
                )

                // Displays the main result message
                // يعرض رسالة نتيجة الهدف
                Text(
                    goalAchieved
                    ? "Well done!"
                    : "You didn't reach your goal this time."
                )
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.center)

                // Displays the supporting message
                // يعرض الرسالة التوضيحية
                Text(
                    goalAchieved
                    ? "Ready for your next goal?"
                    : "Want to set another goal?"
                )
                .font(.system(size: 11))
                .foregroundStyle(Color("SecondaryText"))
                .multilineTextAlignment(.center)
            }

            Spacer()
                .frame(height: 38)

            // MARK: - Set Goal Button
            // زر إنشاء هدف جديد

            Button {
                // Opens the SetNewGoalView page
                // يفتح صفحة إنشاء هدف جديد
                onSetGoal()

            } label: {

                Label("Set a goal", systemImage: "pencil")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color("PrimaryText"))
                    .padding(.horizontal, 16)
                    .frame(height: 34)
                    .background(Color("AccentOrange"))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Preview
// معاينة الصفحة داخل Xcode

#Preview {
    NavigationStack {
        GoalCompletionView(goalAchieved: true) {
            print("Set a goal")
        }
        .background(Color("MainBG"))
    }
}
