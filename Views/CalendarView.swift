//
//  CalendarView.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//

import SwiftUI

struct CalendarView: View {

    @ObservedObject var viewModel: ActivityViewModel

    @State private var currentMonth = Date()

    private let calendar = Calendar.current

    private let weekdays = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {

        ZStack {

            Color("MainBG")
                .ignoresSafeArea()

            VStack(spacing: 25) {

                // MARK: - Header

                Text("Learning History")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundStyle(Color("PrimaryText"))

                // MARK: - Month Navigation

                HStack {

                    Button {
                        changeMonth(by: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(Color("PrimaryText"))
                    }

                    Spacer()

                    Text(currentMonth.formatted(.dateTime.month(.wide).year()))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color("PrimaryText"))

                    Spacer()

                    Button {
                        changeMonth(by: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color("PrimaryText"))
                    }
                    .disabled(calendar.isDate(
                        currentMonth,
                        equalTo: Date(),
                        toGranularity: .month
                    ))
                }
                .padding(.horizontal, 15)

                // MARK: - Weekday Labels

                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 7
                    )
                ) {

                    ForEach(Array(weekdays.enumerated()), id: \.offset) { _, day in

                        Text(day)
                            .font(.system(size: 13))
                            .foregroundStyle(Color("SecondaryText"))
                    }
                }

                // MARK: - Calendar Days

                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible()),
                        count: 7
                    ),
                    spacing: 15
                ) {

                    ForEach(Array(monthDays.enumerated()), id: \.offset) { _, date in

                        if let date {

                            calendarDay(date)

                        } else {

                            Color.clear
                                .frame(height: 38)
                        }
                    }
                }

                // MARK: - Legend

                HStack(spacing: 20) {

                    legend(color: Color("AccentOrange"), title: "Learned")

                    legend(color: .cyan, title: "Freezed")
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 25)
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Calendar Day Cell

    private func calendarDay(_ date: Date) -> some View {

        let status = viewModel.progress.dailyRecords[dateKey(date)]

        let backgroundColor: Color = {

            switch status {
            case .learned:
                return Color("AccentOrange")

            case .freezed:
                return .cyan

            case nil:
                return Color("InactiveButton")
            }
        }()

        return Text(date.formatted(.dateTime.day()))
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color("PrimaryText"))
            .frame(width: 38, height: 38)
            .background(backgroundColor)
            .clipShape(Circle())
    }

    // MARK: - Month Dates

    private var monthDays: [Date?] {

        guard let interval = calendar.dateInterval(
            of: .month,
            for: currentMonth
        ),
        let numberOfDays = calendar.range(
            of: .day,
            in: .month,
            for: currentMonth
        ) else {
            return []
        }

        let firstWeekday = calendar.component(
            .weekday,
            from: interval.start
        )

        let leadingSpaces = (firstWeekday + 5) % 7

        var dates: [Date?] = Array(
            repeating: nil,
            count: leadingSpaces
        )

        for day in numberOfDays {

            if let date = calendar.date(
                byAdding: .day,
                value: day - 1,
                to: interval.start
            ) {
                dates.append(date)
            }
        }

        return dates
    }

    // MARK: - Date Key

    private func dateKey(_ date: Date) -> String {

        calendar.startOfDay(for: date).formatted(
            .iso8601.year().month().day()
        )
    }

    // MARK: - Change Month

    private func changeMonth(by value: Int) {

        if let newMonth = calendar.date(
            byAdding: .month,
            value: value,
            to: currentMonth
        ) {
            currentMonth = newMonth
        }
    }

    // MARK: - Calendar Legend

    private func legend(color: Color, title: String) -> some View {

        HStack(spacing: 6) {

            Circle()
                .fill(color)
                .frame(width: 10, height: 10)

            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Color("SecondaryText"))
        }
    }
}

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

