//
//  LearningProgress.swift
//  Views
//
//  Created by Linah on 01/06/1448 AH.
//



import Foundation

// Defines the status of each learning day
// نحدد حالة كل يوم في سجل التعلم
enum DayStatus: String, Codable {
    
    // The user completed learning on this day
    // المستخدم سجل هذا اليوم كيوم تعلم
    case learned
    
    // The user used a Freeze to protect the streak
    // المستخدم استخدم Freeze لحماية سلسلة الاستمرارية
    case freezed
}


// Stores the user's learning progress
// نخزن جميع البيانات المتعلقة بتقدم المستخدم في التعلم
struct LearningProgress: Codable {
    
    // Stores the user's learning goal
    // يخزن هدف التعلم الذي أدخله المستخدم
    var learningGoal: String
    
    // Stores the duration selected by the user
    // يخزن المدة التي اختارها المستخدم: أسبوع أو شهر أو سنة
    var selectedDuration: LearningDuration
    
    // Stores the date when the user started the goal
    // يخزن تاريخ بداية هدف التعلم
    var goalStartDate: Date = Date()
    
    // Stores the current learning streak
    // يخزن عدد أيام الاستمرارية الحالية
    var currentStreak: Int = 0
    
    // Stores the number of freezes already used
    // يخزن عدد مرات استخدام Freeze
    var usedFreezes: Int = 0
    
    // Stores the date of the user's last activity
    // يخزن تاريخ آخر نشاط للمستخدم
    // Optional because the user may not have any activity yet
    // استخدمنا Optional لأن المستخدم قد لا يكون لديه نشاط سابق
    var lastActivityDate: Date? = nil
    
    // Stores the status of each recorded day
    // يخزن حالة كل يوم باستخدام التاريخ كمفتاح والحالة كقيمة
    var dailyRecords: [String: DayStatus] = [:]
    
    // Stores the number of learned days for the current goal
    // يخزن عدد أيام التعلم المحققة في الهدف الحالي فقط
   
    var goalLearnedDays: Int = 0
    // Calculates the required number of learning days
    // يحسب عدد أيام التعلم المطلوبة لإكمال الهدف
    var requiredLearningDays: Int {
        
        // Check the duration selected by the user
        // نتحقق من المدة التي اختارها المستخدم
        switch selectedDuration {
            
        // A week requires 7 learning days
        // الأسبوع يحتاج إلى 7 أيام تعلم
        case .week:
            return 7
            
        // A month temporarily requires 30 learning days
        // الشهر يحتاج مؤقتاً إلى 30 يوم تعلم
        case .month:
            return 30
            
        // A year requires 365 learning days
        // السنة تحتاج إلى 365 يوم تعلم
        case .year:
            return 365
        }
    }
    
    
    // Calculates the goal's end date
    // يحسب تاريخ نهاية فترة الهدف بناءً على عدد الأيام المطلوبة
    var goalEndDate: Date {
        
        // Add the required number of days to the start date
        // نضيف عدد الأيام المطلوبة إلى تاريخ بداية الهدف
        Calendar.current.date(
            byAdding: .day,
            value: requiredLearningDays,
            to: goalStartDate
        ) ?? goalStartDate
    }
    
    
    // Calculates the maximum number of freezes
    // يحسب الحد الأقصى لعدد مرات استخدام Freeze حسب مدة التعلم
    var freezeLimit: Int {
        
        // Check the selected learning duration
        // نتحقق من مدة التعلم المختارة
        switch selectedDuration {
            
        // A week allows 2 freezes
        // الأسبوع يسمح باستخدام Freeze مرتين
        case .week:
            return 2
            
        // A month allows 8 freezes
        // الشهر يسمح باستخدام Freeze ثماني مرات
        case .month:
            return 8
            
        // A year allows 96 freezes
        // السنة تسمح باستخدام Freeze 96 مرة
        case .year:
            return 96
        }
    }
    
    
    // Calculates the remaining number of freezes
    // يحسب عدد مرات Freeze المتبقية للمستخدم
    var remainingFreezes: Int {
        
        // Subtract used freezes from the maximum limit
        // نطرح عدد مرات الاستخدام من الحد الأقصى
        // max prevents the result from going below zero
        // max تمنع ظهور نتيجة أقل من صفر
        max(0, freezeLimit - usedFreezes)
    }
}
