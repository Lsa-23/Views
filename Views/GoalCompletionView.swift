//
//  GoalCompletionView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//



import SwiftUI

struct GoalCompletionView: View {

    let goalAchieved: Bool

    let onSetGoal: () -> Void

    var body: some View {

        ZStack {

            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 18) {

                Spacer()

                // MARK: - Result Icon
                // أيقونة نتيجة الهدف

                Image(systemName: goalAchieved ? "hands.clap.fill" : "exclamationmark.octagon.fill")
                    .font(.system(size: 38))
                    .foregroundStyle(
                        goalAchieved
                        ? Color.yellow
                        : Color("AccentOrange")
                    )

                // MARK: - Result Message
                // رسالة نتيجة الهدف

                Text(
                    goalAchieved
                    ? "Well done!"
                    : "You didn't reach your goal this time."
                )
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color("PrimaryText"))
                .multilineTextAlignment(.center)

                Text(
                    goalAchieved
                    ? "Ready for your next goal?"
                    : "Want to set another goal?"
                )
                .font(.system(size: 13))
                .foregroundStyle(Color("SecondaryText"))

                Spacer()

                // MARK: - Set Goal Button
                // زر إنشاء هدف جديد

                Button {

                    // Calls the action provided by ActivityView
                    // ينفذ الأمر القادم من صفحة ActivityView
                    onSetGoal()

                } label: {

                    // The button title stays the same in both cases
                    // اسم الزر ثابت سواء اكتمل الهدف أو لم يكتمل

                    Label("Set a goal", systemImage: "pencil")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color("PrimaryText"))
                        .padding(.horizontal, 20)
                        .frame(height: 42)
                        .background(Color("AccentOrange"))
                        .clipShape(Capsule())
                }

                Spacer()
            }
            .padding(25)
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
// معاينة الصفحة داخل Xcode

#Preview {
    NavigationStack {
        GoalCompletionView(goalAchieved: true) {
            print("Set a goal")
        }
    }
}
