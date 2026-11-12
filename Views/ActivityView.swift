//
//  ActivityView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//



import SwiftUI

struct ActivityView: View {

    // Stores the goal information received from Onboarding
    // يخزن معلومات الهدف التي وصلتنا من صفحة Onboarding
    let learningGoal: String
    let selectedDuration: LearningDuration

    // Manages the user's learning progress
    // يدير تقدم المستخدم في التعلم
    @StateObject private var viewModel: ActivityViewModel

    // Controls showing the SetNewGoalView page
    // يتحكم في إظهار صفحة إنشاء هدف جديد
    @State private var showSetNewGoal = false

    // Initializes the ViewModel using the selected goal
    // ينشئ ViewModel باستخدام الهدف والمدة المختارة
    init(learningGoal: String, selectedDuration: LearningDuration) {

        self.learningGoal = learningGoal
        self.selectedDuration = selectedDuration

        _viewModel = StateObject(
            wrappedValue: ActivityViewModel(
                learningGoal: learningGoal,
                duration: selectedDuration
            )
        )
    }

    var body: some View {

        ZStack {

            // Main background color
            // لون خلفية الصفحة
            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 22) {

                // MARK: - Header
                // الجزء العلوي من الصفحة

                HStack {

                    VStack(alignment: .leading, spacing: 5) {

                        Text("Activity")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundStyle(Color("PrimaryText"))

                        Text(Date.now.formatted(date: .complete, time: .omitted))
                            .font(.system(size: 11))
                            .foregroundStyle(Color("SecondaryText"))
                    }

                    Spacer()

                    // Opens the learning calendar
                    // يفتح صفحة تقويم التعلم
                    NavigationLink {
                        CalendarView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "calendar")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("InactiveButton"))
                            .clipShape(Circle())
                    }

                    // Opens the edit learning goal page
                    // يفتح صفحة تعديل هدف التعلم
                    NavigationLink {
                        EditLearningGoalView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(Color("PrimaryText"))
                            .frame(width: 38, height: 38)
                            .background(Color("InactiveButton"))
                            .clipShape(Circle())
                    }
                }

                // MARK: - Weekly Calendar
                // تقويم أيام الأسبوع الحالي

                HStack(spacing: 0) {

                    ForEach(weekDates, id: \.self) { date in

                        VStack(spacing: 8) {

                            // Displays the weekday name
                            // يعرض اسم يوم الأسبوع
                            Text(date.formatted(.dateTime.weekday(.narrow)))
                                .font(.system(size: 11))
                                .foregroundStyle(Color("SecondaryText"))

                            // Displays the day number
                            // يعرض رقم اليوم
                            Text(date.formatted(.dateTime.day()))
                                .font(.system(size: 13, weight: .medium))
                                .foregroundStyle(
                                    Calendar.current.isDateInToday(date)
                                    ? Color("MainBG")
                                    : Color("PrimaryText")
                                )
                                .frame(width: 25, height: 25)
                                .background(
                                    Calendar.current.isDateInToday(date)
                                    ? Color("AccentOrange")
                                    : Color.clear
                                )
                                .clipShape(Circle())
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                // MARK: - Statistics Cards
                // بطاقات إحصائيات التعلم

                HStack(spacing: 10) {

                    // Displays the current learning streak
                    // يعرض عدد أيام الاستمرارية الحالية
                    statCard(
                        icon: "flame.fill",
                        value: "\(viewModel.progress.currentStreak) \(viewModel.dayWord(for: viewModel.progress.currentStreak))",
                        label: "Streak",
                        color: Color("AccentOrange")
                    )

                    // Displays the number of used freezes
                    // يعرض عدد مرات استخدام Freeze
                    statCard(
                        icon: "snowflake",
                        value: "\(viewModel.progress.usedFreezes) \(viewModel.freezeWord(for: viewModel.progress.usedFreezes))",
                        label: "Freezes used",
                        color: .cyan
                    )
                }

                Spacer(minLength: 10)

                // MARK: - Goal Content
                // محتوى الصفحة حسب حالة الهدف

                if viewModel.goalStatus == .active {

                    // Shows the learning buttons while the goal is active
                    // يعرض أزرار التعلم ما دام الهدف مستمراً
                    activeGoalContent

                } else {

                    // Shows the result when the goal period ends
                    // يعرض نتيجة الهدف عند انتهاء مدته
                    GoalCompletionView(
                        goalAchieved: viewModel.goalStatus == .completed,
                        onSetGoal: {

                            // Opens the SetNewGoalView page
                            // يفتح صفحة إنشاء هدف جديد عند الضغط على Set a goal
                            showSetNewGoal = true
                        }
                    )
                }

                Spacer(minLength: 10)
            }
            .padding(.horizontal, 18)
            .padding(.top, 15)
            .padding(.bottom, 20)
        }

        // Hides the default navigation back button
        // يخفي زر الرجوع الافتراضي
        .navigationBarBackButtonHidden(true)

        // Checks the streak when the page appears
        // يتحقق من الـ Streak عند ظهور الصفحة
        .onAppear {
            viewModel.checkStreakReset()
        }

        // Opens SetNewGoalView as a separate sheet
        // يفتح صفحة إنشاء هدف جديد داخل نافذة مستقلة
        .sheet(isPresented: $showSetNewGoal) {
            NavigationStack {
                SetNewGoalView(viewModel: viewModel)
            }
        }
    }

    // MARK: - Active Goal Content
    // محتوى الهدف النشط

    private var activeGoalContent: some View {

        VStack(spacing: 22) {

            // MARK: - Learned Button
            // زر تسجيل يوم التعلم

            Button {

                // Records today as a learned day
                // يسجل اليوم كيوم تعلم
                viewModel.logLearned()

            } label: {

                VStack(spacing: 5) {

                    Text(
                        viewModel.todayStatus == .learned
                        ? "Logged as Learned"
                        : viewModel.todayStatus == .freezed
                        ? "Day Freezed"
                        : "Log as Learned"
                    )
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("PrimaryText"))
                }
                .frame(width: 180, height: 180)
                .background(
                    viewModel.canLogLearned
                    ? Color("AccentOrange")
                    : Color("InactiveButton")
                )
                .clipShape(Circle())
            }
            .disabled(!viewModel.canLogLearned)

            // MARK: - Freeze Button
            // زر استخدام Freeze

            VStack(spacing: 8) {

                Button {

                    // Uses one freeze for today
                    // يستخدم Freeze لهذا اليوم
                    viewModel.freezeDay()

                } label: {

                    Text(
                        viewModel.todayStatus == .freezed
                        ? "Day Freezed"
                        : viewModel.todayStatus == .learned
                        ? "Already Learned"
                        : "Freeze for a day"
                    )
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("PrimaryText"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(
                        viewModel.canFreeze
                        ? Color.cyan
                        : Color("InactiveButton")
                    )
                    .clipShape(Capsule())
                }
                .disabled(!viewModel.canFreeze)

                // Displays the number of used freezes
                // يعرض عدد مرات استخدام Freeze من إجمالي الرصيد
                Text(
                    "\(viewModel.progress.usedFreezes) out of \(viewModel.progress.freezeLimit) Freezes used"
                )
                .font(.system(size: 10))
                .foregroundStyle(Color("SecondaryText"))
            }
        }
    }

    // MARK: - Statistics Card
    // تصميم بطاقة الإحصائيات

    private func statCard(
        icon: String,
        value: String,
        label: String,
        color: Color
    ) -> some View {

        VStack(spacing: 5) {

            // Displays the card icon
            // يعرض أيقونة البطاقة
            Image(systemName: icon)
                .font(.system(size: 17))
                .foregroundStyle(color)

            // Displays the statistic value
            // يعرض قيمة الإحصائية
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color("PrimaryText"))

            // Displays the statistic title
            // يعرض اسم الإحصائية
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(Color("SecondaryText"))
        }
        .frame(maxWidth: .infinity)
        .frame(height: 65)
        .background(Color("InactiveButton"))
        .clipShape(RoundedRectangle(cornerRadius: 17))
        .overlay {
            RoundedRectangle(cornerRadius: 17)
                .stroke(Color("Divider"), lineWidth: 1)
        }
    }

    // MARK: - Current Week Dates
    // حساب تواريخ أيام الأسبوع الحالي

    private var weekDates: [Date] {

        let calendar = Calendar.current

        // Gets today's date without the time
        // يحصل على تاريخ اليوم بدون الوقت
        let today = calendar.startOfDay(for: Date())

        // Gets the current weekday number
        // يحصل على رقم يوم الأسبوع
        let weekday = calendar.component(.weekday, from: today)

        // Calculates the number of days since Monday
        // يحسب عدد الأيام منذ يوم الاثنين
        let startOffset = (weekday + 5) % 7

        // Finds the date of Monday
        // يحدد تاريخ يوم الاثنين
        guard let monday = calendar.date(
            byAdding: .day,
            value: -startOffset,
            to: today
        ) else {
            return [today]
        }

        // Returns all seven dates starting from Monday
        // يرجع تواريخ الأيام السبعة ابتداءً من الاثنين
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: monday)
        }
    }
}

// MARK: - Preview
// معاينة صفحة النشاط داخل Xcode

#Preview {
    NavigationStack {
        ActivityView(
            learningGoal: "Swift",
            selectedDuration: .week
        )
    }
}
