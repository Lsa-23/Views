//
//  ActivityViewModel.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//








import Foundation
import Combine

// Defines the possible states of the learning goal
// نحدد الحالات الممكنة لهدف التعلم
enum GoalStatus: Equatable {

    // The user is still working toward the goal
    // المستخدم لا يزال يعمل على تحقيق الهدف
    case active

    // The user completed the required learning days
    // المستخدم أكمل عدد أيام التعلم المطلوبة
    case completed

    // The goal period ended before completing the required days
    // انتهت مدة الهدف قبل إكمال أيام التعلم المطلوبة
    case notMet
}

class ActivityViewModel: ObservableObject {

    // Stores all learning progress and updates the UI when changed
    // يخزن تقدم المستخدم ويحدث الواجهة عند تغيير البيانات
    @Published var progress: LearningProgress

    // Defines the key used to save and retrieve progress from UserDefaults
    // يحدد اسم المفتاح المستخدم لحفظ واسترجاع التقدم
    private let storageKey = "LearningProgress"

    // Initializes the learning progress
    // يجهز بيانات تقدم المستخدم عند فتح صفحة Activity
    init(learningGoal: String, duration: LearningDuration) {

        // Check if saved progress exists on the device
        // نتحقق إذا كان هناك تقدم محفوظ مسبقاً على الجهاز
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let savedProgress = try? JSONDecoder().decode(
                LearningProgress.self,
                from: savedData
           ) {

            // Restore the previously saved progress
            // نسترجع تقدم المستخدم السابق
            progress = savedProgress

            // Check if the user entered a different goal or duration
            // نتحقق إذا كان المستخدم اختار هدفاً أو مدة مختلفة
            if progress.learningGoal != learningGoal ||
                progress.selectedDuration != duration {

                // Start a new goal when the selected information changes
                // نبدأ هدفاً جديداً إذا تغير الهدف أو المدة
                updateGoal(goal: learningGoal, duration: duration)
            }

        } else {

            // Create new progress if no saved data exists
            // ننشئ بيانات تقدم جديدة إذا لم نجد بيانات محفوظة
            progress = LearningProgress(
                learningGoal: learningGoal,
                selectedDuration: duration
            )
        }

        // Check whether the streak needs to be reset
        // نتحقق إذا كان يجب تصفير الـ Streak
        checkStreakReset()

        // Save the latest progress
        // نحفظ آخر تحديث للتقدم
        saveProgress()
    }

    // MARK: - Date Management
    // إدارة التواريخ

    // Returns today's date as a unique key
    // يحول تاريخ اليوم إلى مفتاح نستخدمه في سجل الأيام
    private var todayKey: String {
        Calendar.current.startOfDay(for: Date()).formatted(
            .iso8601.year().month().day()
        )
    }

    // MARK: - Daily Activity
    // نشاط اليوم

    // Checks today's recorded activity
    // يتحقق من حالة نشاط المستخدم في يومنا الحالي
    var todayStatus: DayStatus? {
        progress.dailyRecords[todayKey]
    }

    // Calculates the number of learned days for the current goal
    // يعرض عدد أيام التعلم التي حققها المستخدم في الهدف الحالي
    var learnedDaysCount: Int {
        progress.goalLearnedDays
    }
      // تراجع دل
    // Checks whether today's Learned action can be undone
    // يتحقق إذا كان بإمكان المستخدم التراجع عن تسجيل تعلم اليوم
    //هذه الخاصية تتأكد من وجود تسجيل تعلم اليوم ومن إمكانية التراجع عنه.
    var canUndoLearned: Bool {
        todayStatus == .learned &&
        progress.hasUndoSnapshot == true
    }

    // MARK: - Goal Status
    // حالة هدف التعلم

    // Calculates the goal completion status
    // يحدد حالة الهدف بناءً على أيام التعلم وتاريخ النهاية
    var goalStatus: GoalStatus {

        // Check if the user completed all required learning days
        // نتحقق أولاً إذا كان المستخدم أكمل أيام التعلم المطلوبة
        if progress.goalLearnedDays >= progress.requiredLearningDays {
            return .completed
        }

        // Check if the goal period has ended
        // نتحقق إذا انتهت المدة المحددة للهدف
        if Date() >= progress.goalEndDate {
            return .notMet
        }

        // Otherwise, the goal is still active
        // إذا لم يتحقق أي شرط، فالهدف لا يزال مستمراً
        return .active
    }
     //DL1
     // دليل منع الحالتين في اليوم نفسله
    // Checks if the user can log today as learned
    // يتحقق إذا كان بإمكان المستخدم تسجيل اليوم كيوم تعلم
    var canLogLearned: Bool {
        todayStatus == nil && goalStatus == .active //تتسجل حسب ايش ضغط اليوزر
    }
       //DL2
      //دليل منع الحالتين في اليوم نفسه
    // Checks if the user can freeze today
    // يتحقق إذا كان بإمكان المستخدم استخدام Freeze اليوم
    var canFreeze: Bool {
        todayStatus == nil && //تتسجل حسب ايش ضغط اليوزر
        progress.remainingFreezes > 0 &&
        goalStatus == .active
    }

    // MARK: - Streak Management
    // إدارة سلسلة الاستمرارية

    // Resets the streak after more than 32 hours without activity
    // يصفر الـ Streak إذا مر أكثر من 32 ساعة بدون تسجيل نشاط
    func checkStreakReset() {

        // Check if a previous activity date exists
        // نتحقق من وجود تاريخ آخر نشاط
        guard let lastDate = progress.lastActivityDate else {
            return
        }

        // Calculate the number of hours since the last activity
        // نحسب عدد الساعات التي مرت منذ آخر نشاط
        let hoursPassed = Date().timeIntervalSince(lastDate) / 3600

        // Reset the streak if more than 32 hours have passed
        // نصفر الـ Streak إذا تجاوز الوقت 32 ساعة
        if hoursPassed > 32 {

            progress.currentStreak = 0

            // Notify the interface that the progress has changed
            // نخبر الواجهة أن بيانات التقدم تغيرت
            objectWillChange.send()

            // Save the updated progress after resetting the streak
            // نحفظ التقدم بعد تصفير الـ Streak
            saveProgress()
        }
    }

    // MARK: - Log Learned
    // تسجيل يوم التعلم

    // Logs today as a learned day
    // يسجل اليوم كيوم تعلم
    func logLearned() {

        // Stop if the user cannot log today
        // نوقف العملية إذا لم يكن بإمكان المستخدم التسجيل اليوم
        guard canLogLearned else {
            return
        }

        // Save the previous streak before changing it
        // نحفظ قيمة الـ Streak السابقة قبل تغييرها
        progress.previousCurrentStreak = progress.currentStreak

        // Save the previous learned days count
        // نحفظ عدد أيام التعلم السابقة
        progress.previousGoalLearnedDays = progress.goalLearnedDays

        // Save the previous last activity date
        // نحفظ تاريخ آخر نشاط سابق
        progress.previousLastActivityDate = progress.lastActivityDate

        // Mark that the previous values are available for Undo
        // نحدد أن القيم السابقة محفوظة ويمكن استخدامها للتراجع
        progress.hasUndoSnapshot = true

        // Record today's status as learned
        // نسجل حالة اليوم على أنها تعلم
        progress.dailyRecords[todayKey] = .learned

        // Increase the current streak by one day
        // نزيد عدد أيام الـ Streak بمقدار يوم
        progress.currentStreak += 1

        // Increase the learned days count for the current goal
        // نزيد عدد أيام التعلم المحققة للهدف الحالي
        progress.goalLearnedDays += 1

        // Update the last activity date
        // نحدث تاريخ آخر نشاط للمستخدم
        progress.lastActivityDate = Date()

        // Notify the interface that the progress has changed
        // نخبر الواجهة أن بيانات التقدم تغيرت
        objectWillChange.send()

        // Print the current streak for debugging
        // نطبع قيمة الـ Streak للتأكد من تحديثها في Xcode
        print("Current Streak: \(progress.currentStreak)")

        // Save the updated progress
        // نحفظ التقدم بعد تسجيل يوم التعلم
        saveProgress()
    }
        //DL3
    //هذا يثبت إمكانية التراجع واسترجاع القيم السابقة.

    // MARK: - Undo Learned دليل
    // التراجع عن تسجيل يوم التعلم
    // Removes today's learned record and restores the previous values
    // يحذف تسجيل تعلم اليوم ويرجع القيم السابقة كما كانت
    func undoLearned() {

        // Stop if today's learned action cannot be undone
        // نوقف العملية إذا لم يكن هناك تسجيل تعلم يمكن التراجع عنه
        guard canUndoLearned else {
            return
        }

        // Remove today's learned record
        // نحذف تسجيل التعلم الخاص بهذا اليوم
        progress.dailyRecords.removeValue(forKey: todayKey)

        // Restore the previous streak value
        // نرجع قيمة الـ Streak إلى ما كانت عليه
        if let previousStreak = progress.previousCurrentStreak {
            progress.currentStreak = previousStreak
        }

        // Restore the previous learned days count
        // نرجع عدد أيام التعلم إلى ما كان عليه
        if let previousLearnedDays = progress.previousGoalLearnedDays {
            progress.goalLearnedDays = previousLearnedDays
        }

        // Restore the previous last activity date
        // نرجع تاريخ آخر نشاط إلى قيمته السابقة
        progress.lastActivityDate = progress.previousLastActivityDate

        // Clear the saved Undo values after restoring them
        // نمسح القيم المحفوظة بعد استخدامها في التراجع
        progress.previousCurrentStreak = nil
        progress.previousGoalLearnedDays = nil
        progress.previousLastActivityDate = nil
        progress.hasUndoSnapshot = false

        // Notify the interface that the progress has changed
        // نخبر الواجهة أن بيانات التقدم تغيرت
        objectWillChange.send()

        // Save the restored progress
        // نحفظ التقدم بعد التراجع عن التسجيل
        saveProgress()
    }
     //DL4
    //هذا يثبت تسجيل اليوم كـ Frozen.
    // MARK: - Freeze Day
    // استخدام Freeze

    // Freezes today to protect the current streak
    // يستخدم Freeze لحماية الـ Streak في هذا اليوم
    func freezeDay() {

        // Stop if the user cannot freeze today
        // نوقف العملية إذا لم يكن بإمكان المستخدم استخدام Freeze
        guard canFreeze else {
            return
        }
            //دليل فريز
        // Record today's status as freezed
        // نسجل حالة اليوم على أنها Freeze
        // هنا بمجرديضغط اليوزر عليها تصيز التوداي ستايت فريزد وهنا بيتقفل لوق از ليرند ومارح يتحقق الشرط
        progress.dailyRecords[todayKey] = .freezed

        // Increase the number of used freezes
        // نزيد عدد مرات استخدام Freeze
        progress.usedFreezes += 1

        // Update the last activity date to protect the streak
        // نحدث تاريخ آخر نشاط حتى نحافظ على الـ Streak
        progress.lastActivityDate = Date()

        // Clear any previous Undo data
        // نمسح أي بيانات تراجع سابقة
        progress.previousCurrentStreak = nil
        progress.previousGoalLearnedDays = nil
        progress.previousLastActivityDate = nil
        progress.hasUndoSnapshot = false

        // Notify the interface that the progress has changed
        // نخبر الواجهة أن بيانات التقدم تغيرت
        objectWillChange.send()

        // Save the updated progress
        // نحفظ التقدم بعد استخدام Freeze
        saveProgress()
    }

    // MARK: - Update Goal
    // تحديث هدف التعلم

    // Updates the learning goal and duration
    // يحدث هدف التعلم والمدة المختارة
    func updateGoal(goal: String, duration: LearningDuration) {

        // Update the goal information
        // نحدث معلومات الهدف
        progress.learningGoal = goal
        progress.selectedDuration = duration

        // Set a new start date for the goal
        // نحدد تاريخ بداية جديد للهدف
        progress.goalStartDate = Date()

        // Reset the streak when the goal changes
        // نصفر الـ Streak عند تغيير الهدف
        progress.currentStreak = 0

        // Reset the used freezes for the new goal
        // نعيد عدد مرات Freeze المستخدمة إلى صفر للهدف الجديد
        progress.usedFreezes = 0

        // Reset the learned days count for the new goal
        // نصفر عدد أيام التعلم المحققة للهدف الجديد
        progress.goalLearnedDays = 0

        // Reset the last activity date
        // نمسح تاريخ آخر نشاط للهدف السابق
        progress.lastActivityDate = nil

        // Clear all saved Undo values for the previous goal
        // نمسح جميع بيانات التراجع الخاصة بالهدف السابق
        progress.previousCurrentStreak = nil
        progress.previousGoalLearnedDays = nil
        progress.previousLastActivityDate = nil
        progress.hasUndoSnapshot = false

        // Remove today's previous record so the user can log activity again
        // نحذف تسجيل اليوم السابق فقط حتى يستطيع المستخدم التسجيل مع الهدف الجديد
        progress.dailyRecords.removeValue(forKey: todayKey)

        // Notify the interface that the progress has changed
        // نخبر الواجهة أن بيانات التقدم تغيرت
        objectWillChange.send()

        // Save the new goal information
        // نحفظ معلومات الهدف الجديد
        saveProgress()
    }

    // MARK: - Save Progress
    // حفظ التقدم

    // Saves progress on the device
    // يحفظ تقدم المستخدم على الجهاز باستخدام UserDefaults
    private func saveProgress() {

        // Try to encode the progress into Data
        // نحاول تحويل بيانات التقدم إلى Data حتى يمكن حفظها
        if let encodedData = try? JSONEncoder().encode(progress) {

            // Save the encoded data using UserDefaults
            // نحفظ البيانات باستخدام UserDefaults
            UserDefaults.standard.set(encodedData, forKey: storageKey)
        }
    }

    // MARK: - Text Helpers
    // دوال مساعدة للنصوص

    // Returns the correct singular or plural word for days
    // يرجع الكلمة المناسبة حسب عدد الأيام: مفرد أو جمع
    func dayWord(for number: Int) -> String {
        number == 1 ? "Day" : "Days"
    }

    // Returns the correct singular or plural word for freezes
    // يرجع الكلمة المناسبة حسب عدد مرات Freeze
    func freezeWord(for number: Int) -> String {
        number == 1 ? "Freeze" : "Freezes"
    }
}
