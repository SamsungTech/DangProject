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
}
