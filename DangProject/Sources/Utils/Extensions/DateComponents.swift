//
//  DateComponents.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/19.
//

import Foundation

extension DateComponents {
    static func currentDateTimeComponents() -> DateComponents {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
    
    static func currentDateComponents() -> DateComponents {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
    
    static func currentYearMonth() -> DateComponents {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month
        ]
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
    
    static func makeDateCompontents(from date: Date) -> DateComponents {
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day
        ]
        return userCalendar.dateComponents(requestedComponents, from: date)
    }
    
    static func configureDateComponents(_ dateComponents: DateComponents) -> DateComponents {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        guard let changedDate = calendar.date(from: dateComponents) else { return DateComponents.init() }
        
        return DateComponents.makeDateCompontents(from: changedDate)
    }
}
