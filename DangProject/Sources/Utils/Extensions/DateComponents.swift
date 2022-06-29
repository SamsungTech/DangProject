//
//  DateComponents.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/09.
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

extension Date {
    static func currentDate() -> Date {
        let currentDateComponents = DateComponents.currentDateTimeComponents()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        guard let year = currentDateComponents.year,
              let month = currentDateComponents.month,
              let day = currentDateComponents.day
        else {
            return Date.init()
        }
        let myDateComponents = DateComponents(year: year , month: month, day: day)
        return calendar.date(from: myDateComponents) ?? Date.init()
    }
    
    static func currentTime() -> Date {
        let currentDateComponents = DateComponents.currentDateTimeComponents()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        guard let hour = currentDateComponents.hour,
              let minute = currentDateComponents.minute,
              let second = currentDateComponents.second
        else {
            return Date.init()
        }
        let myDateComponents = DateComponents(hour: hour,
                                              minute: minute,
                                              second: second)
        return calendar.date(from: myDateComponents) ?? Date.init()
    }
    
    static func makeDate(year: Int?, month: Int?, day: Int?) -> Date {
        guard let year = year,
              let month = month,
              let day = day else {
            return Date.init()
        }
        let myDateComponents = DateComponents(year: year, month: month, day: day)
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let myDate = calendar.date(from: myDateComponents)
        return myDate ?? Date.init()
    }
    
    
}
