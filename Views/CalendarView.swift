//
//  CalendarView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//


import SwiftUI

struct CalendarView: View {

    // Receives the ViewModel to access saved learning records
    // يستقبل الـ ViewModel للوصول إلى سجلات التعلّم المحفوظة
    @ObservedObject var viewModel: ActivityViewModel

    // Starts the calendar from January of the current year
    // يبدأ التقويم من شهر يناير للسنة الحالية
    @State private var currentMonth = Calendar.current.date(
        from: Calendar.current.dateComponents([.year], from: Date())
    ) ?? Date()

    // Provides calendar and date calculation functions
    // يوفر وظائف التقويم وحساب التواريخ
    private let calendar = Calendar.current

    // Stores the weekday labels displayed above the calendar
    // يخزن اختصارات أيام الأسبوع التي تظهر أعلى التقويم
    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {

        ZStack {

            // Sets the background color of the calendar screen
            // يحدد لون خلفية شاشة التقويم
            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // MARK: - Header

                // Displays the calendar screen title
                // يعرض عنوان شاشة التقويم
                Text("Learning History")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(Color("PrimaryText"))

                // MARK: - Month Navigation

                // Provides buttons to navigate between months
                // يوفر أزرار التنقل بين الأشهر
                HStack {

                    // Moves to the previous month
                    // ينتقل إلى الشهر السابق
                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("PrimaryText"))
                    }

                    Spacer()

                    // Displays the currently selected month and year
                    // يعرض الشهر والسنة المحددين حاليًا
                    Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    // Moves to the next month
                    // ينتقل إلى الشهر التالي
                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color("PrimaryText"))
                    }

                    // Disables forward navigation when the current month is reached
                    // يعطل الانتقال للأمام عند الوصول إلى الشهر الحالي
                    .disabled(calendar.isDate(
                        currentMonth,
                        equalTo: Date(),
                        toGranularity: .month
                    ))
                }
                .padding(.horizontal, 15)

                // MARK: - Weekday Labels

                // Creates a seven-column grid for weekday names
                // ينشئ شبكة من سبعة أعمدة لأسماء أيام الأسبوع
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 7
                    )
                ) {

                    // Displays each weekday abbreviation
                    // يعرض اختصار كل يوم من أيام الأسبوع
                    ForEach(Array(weekdays.enumerated()), id: \.offset) { _, day in
                        Text(day)
                            .font(.system(size: 13))
                            .foregroundStyle(Color("SecondaryText"))
                    }
                }

                // MARK: - Calendar Days

                // Creates a seven-column grid for the days of the month
                // ينشئ شبكة من سبعة أعمدة لعرض أيام الشهر
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 7
                    ),
                    spacing: 15
                ) {

                    // Iterates through the dates and empty spaces
                    // يمر على التواريخ والخانات الفارغة
                    ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in

                        if let date {

                            // Displays a calendar cell for a valid date
                            // يعرض خلية التقويم عندما يكون التاريخ موجودًا
                            calendarDay(date)

                        } else {

                            // Adds an empty space to align the first weekday
                            // يضيف خانة فارغة لمحاذاة أول يوم مع يوم الأسبوع الصحيح
                            Color.clear
                                .frame(height: 38)
                        }
                    }
                }

                // MARK: - Legend

                // Explains the colors used for each day status
                // يوضح معنى الألوان المستخدمة لحالات الأيام
                HStack(spacing: 20) {
                    legend(color: Color("AccentOrange"), title: "Learned")
                    legend(color: .cyan, title: "Freezed")
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 25)
        }

        // Uses the inline navigation bar title display mode
        // يحدد طريقة عرض عنوان شريط التنقل
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Calendar Day Cell

    // Creates the visual appearance of a single calendar day
    // ينشئ الشكل المرئي لليوم الواحد في التقويم
    private func calendarDay(_ date: Date) -> some View {

        // Gets the saved status of the selected date from the ViewModel
        // يجلب حالة التاريخ من سجلات ViewModel
        let status = viewModel.progress.dailyRecords[dateKey(date)]

        // Selects a background color based on the day's status
        // يحدد لون الخلفية حسب حالة اليوم
        let backgroundColor: Color = {
            switch status {

            // Orange indicates a learned day
            // البرتقالي يدل على يوم تعلّم
            case .learned:
                return Color("AccentOrange")

            // Cyan indicates a frozen day
            // السماوي يدل على يوم تجميد
            case .freezed:
                return .cyan

            // The default color indicates a day without a record
            // اللون الافتراضي يدل على يوم ليس له سجل
            case nil:
                return Color("InactiveButton")
            }
        }()

        // Displays the day number inside a colored circle
        // يعرض رقم اليوم داخل دائرة ملونة
        return Text(date.formatted(.dateTime.day()))
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color("PrimaryText"))
            .frame(width: 38, height: 38)
            .background(backgroundColor)
            .clipShape(Circle())
    }

    // MARK: - Month Dates

    // Generates the dates and empty spaces for the selected month
    // ينشئ تواريخ الشهر المحدد والخانات الفارغة اللازمة لترتيبها
    private var monthDays: [Date?] {

        // Gets the date interval of the selected month
        // يجلب الفترة الزمنية للشهر المحدد
        guard let interval = calendar.dateInterval(
            of: .month,
            for: currentMonth
        ),

        // Gets the valid day numbers in the selected month
        // يجلب أرقام الأيام الموجودة في الشهر
        let numberOfDays = calendar.range(
            of: .day,
            in: .month,
            for: currentMonth
        ) else {

            // Returns an empty array if date information is unavailable
            // يرجع مصفوفة فارغة إذا لم تتوفر معلومات التاريخ
            return []
        }

        // Gets the weekday number of the first day of the month
        // يحدد رقم يوم الأسبوع الذي يبدأ فيه الشهر
        let firstWeekday = calendar.component(
            .weekday,
            from: interval.start
        )

        // Calculates the empty spaces before the first day
        // يحسب عدد الخانات الفارغة قبل أول يوم في الشهر
        let leadingSpaces = (firstWeekday + 5) % 7

        // Creates an array with the required empty spaces
        // ينشئ مصفوفة تحتوي على الخانات الفارغة المطلوبة
        var dates: [Date?] = Array(
            repeating: nil,
            count: leadingSpaces
        )

        // Loops through all day numbers in the month
        // يمر على جميع أرقام أيام الشهر
        for day in numberOfDays {

            // Creates the actual date for each day
            // ينشئ التاريخ الفعلي لكل يوم
            if let date = calendar.date(
                byAdding: .day,
                value: day - 1,
                to: interval.start
            ) {

                // Adds the date to the calendar array
                // يضيف التاريخ إلى مصفوفة التقويم
                dates.append(date)
            }
        }

        // Returns all dates and leading empty spaces
        // يرجع جميع التواريخ والخانات الفارغة
        return dates
    }

    // MARK: - Date Key

    // Converts a date into the format used by the saved daily records
    // يحول التاريخ إلى الصيغة المستخدمة في سجلات الأيام المحفوظة
    private func dateKey(_ date: Date) -> String {

        // Removes the time component and formats the date as year-month-day
        // يتجاهل الوقت ويحول التاريخ إلى صيغة السنة والشهر واليوم
        calendar.startOfDay(for: date).formatted(
            .iso8601.year().month().day()
        )
    }

    // MARK: - Change Month

    // Changes the displayed month based on the given value
    // يغير الشهر المعروض حسب القيمة المستلمة
    private func changeMonth(by value: Int) {

        // Calculates the new month from the currently displayed month
        // يحسب الشهر الجديد انطلاقًا من الشهر المعروض حاليًا
        if let newMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        ) {

            // Updates the selected month and refreshes the calendar
            // يحدث الشهر المحدد ويعيد تحديث التقويم
            currentMonth = newMonth
        }
    }

    // MARK: - Calendar Legend

    // Creates a legend item with a colored circle and a title
    // ينشئ عنصرًا في دليل الألوان يحتوي على دائرة ملونة وعنوان
    private func legend(color: Color, title: String) -> some View {

        HStack(spacing: 6) {

            // Displays the color indicator
            // يعرض الدائرة التي تمثل اللون
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            // Displays the status title next to the color
            // يعرض اسم الحالة بجانب اللون
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Color("SecondaryText"))
        }
    }
}

// MARK: - Preview

// Provides a preview of the calendar inside a NavigationStack
// يعرض معاينة للتقويم داخل NavigationStack
#Preview {

    NavigationStack {

        CalendarView(
            viewModel: ActivityViewModel(
                learningGoal: "Swift",
                duration: .week
            )
        )
    }
}
