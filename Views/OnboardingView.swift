//
//  ContentView.swift
//  Views
//
//  Created by Linah on 30/05/1448 AH.
//








import SwiftUI

struct OnboardingView: View {

    // Connects the View to its ViewModel
    // يربط الواجهة بالـ ViewModel حتى نتمكن من إدارة البيانات والتغييرات
    @StateObject private var viewModel = OnboardingViewModel()

    // Controls navigation to the Activity Page
    // يتحكم في الانتقال إلى صفحة Activity
    @State private var showActivityPage = false

    var body: some View {

        // NavigationStack manages navigation between app screens
        // يدير التنقل بين صفحات التطبيق
        NavigationStack {

            GeometryReader { geometry in

                ZStack {

                    // Main background color
                    // لون خلفية الصفحة
                    Color("MainBG")
                        .ignoresSafeArea()

                    // ScrollView allows scrolling when the screen is small
                    // يسمح بالتمرير إذا كانت مساحة الشاشة غير كافية
                    ScrollView {

                        VStack(spacing: 0) {

                            // MARK: - Flame Symbol
                            // أيقونة الشعلة أعلى الصفحة
                            Image(systemName: "flame.fill")
                                .font(.system(size: 55))
                                .foregroundStyle(Color("AccentOrange"))
                                .padding(.top, 70)

                            Spacer(minLength: 45)

                            // MARK: - Welcome Section
                            // قسم الترحيب بالمستخدم
                            VStack(alignment: .leading, spacing: 10) {

                                HStack(spacing: 0) {

                                    Text("Hello ")
                                        .fontWeight(.regular)

                                    Text("Learner")
                                        .fontWeight(.bold)
                                }
                                .font(.system(size: 42))
                                .foregroundStyle(Color("PrimaryText"))

                                // Displays a welcome message
                                // يعرض رسالة ترحيبية للمستخدم
                                Text("This app will help you learn everyday!")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            Spacer()
                                .frame(height: 25)

                            // MARK: - Learning Goal
                            // قسم تحديد هدف التعلم
                            VStack(alignment: .leading, spacing: 11) {

                                Text("I want to learn")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("PrimaryText"))

                                // Allows the user to enter their learning goal
                                // يسمح للمستخدم بكتابة الشيء الذي يريد تعلمه
                                TextField(
                                    "e.g. English, Swift, or Drawing",
                                    text: $viewModel.learningGoal
                                )
                                .font(.system(size: 16))
                                .foregroundStyle(Color("PrimaryText"))
                                .tint(Color("AccentOrange"))

                                Rectangle()
                                    .fill(Color("Divider"))
                                    .frame(height: 1)
                            }

                            Spacer()
                                .frame(height: 24)

                            // MARK: - Duration Selection
                            // قسم اختيار مدة التعلم
                            VStack(alignment: .leading, spacing: 18) {

                                Text("I want to learn it in a")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Color("PrimaryText"))

                                // Displays the available learning durations
                                // يعرض مدد التعلم المتاحة
                                HStack(spacing: 8) {
                                   
                                    ForEach(LearningDuration.allCases) { duration in
                                     
                                        // Updates the selected duration when tapped
                                        // يحدّث مدة التعلم عند الضغط على الخيار
                                        Button {

                                            viewModel.selectedDuration = duration

                                        } label: {

                                            Text(duration.rawValue)
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundStyle(
                                                    viewModel.selectedDuration == duration
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
                                                        viewModel.selectedDuration == duration
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

                            // Flexible space before the Start Learning button
                            // مساحة مرنة قبل زر بدء التعلم
                            Spacer(minLength: 20)
                                .frame(maxHeight: 232)

                            // MARK: - Start Learning Button
                            // زر بدء التعلم
                            VStack(spacing: 4) {

                                Button {

                                    // Saves the selected goal and duration
                                    // يحفظ هدف التعلم والمدة المختارة
                                    viewModel.startLearning()

                                    // Opens the Activity page
                                    // ينتقل إلى صفحة Activity
                                    showActivityPage = true

                                } label: {

                                    Text("Start Learning")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundStyle(Color("PrimaryText"))
                                        .frame(width: 220, height: 58)
                                        .background(Color("AccentOrange"))
                                        .clipShape(Capsule())
                                }

                                // Prevents starting without entering a valid goal
                                // يمنع بدء التعلم إذا لم يُدخل المستخدم هدفًا صالحًا
                                .disabled(!viewModel.canStartLearning)
                                .opacity(viewModel.canStartLearning ? 1 : 0.5)

                                Text("You can edit your desire later")
                                    .font(.system(size: 15))
                                    .foregroundStyle(Color("SecondaryText"))
                            }
                        }
                        .padding(.horizontal, 28)
                        .padding(.bottom, 2)
                        .frame(minHeight: geometry.size.height)
                    }
                }
            }

            // MARK: - Navigation to Activity
            // الانتقال إلى صفحة Activity
            .navigationDestination(isPresented: $showActivityPage) {

                ActivityView(
                    learningGoal: viewModel.learningGoal,
                    selectedDuration: viewModel.selectedDuration ?? .week
                )
            }
        }

        // Keeps the app appearance in dark mode
        // يحافظ على مظهر التطبيق بالوضع الداكن
        .preferredColorScheme(.dark)
    }
}

// MARK: - Preview
// معاينة صفحة Onboarding داخل Xcode
#Preview {
    OnboardingView()
}
