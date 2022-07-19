//
//  Date.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/19.
//
import Foundation

extension Date {
    
    static let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    
    static func currentDate() -> Date {
        let currentDateComponents = DateComponents.currentDateTimeComponents()
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
    
    static func currentDateTime() -> Date {
        let currentDateComponents = DateComponents.currentDateTimeComponents()
        guard let year = currentDateComponents.year,
              let month = currentDateComponents.month,
              let day = currentDateComponents.day,
              let hour = currentDateComponents.hour,
              let minute = currentDateComponents.minute,
              let second = currentDateComponents.second
        else {
            return Date.init()
        }
        let myDateComponents = DateComponents(year: year ,
                                              month: month,
                                              day: day,
                                              hour: hour,
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
        let myDate = calendar.date(from: myDateComponents)
        return myDate ?? Date.init()
    }
    
    static func makeTime(hour: Int, minute: Int) -> Date {
        let calendar: Calendar = {
            let calendar = Calendar.current
            return calendar
        }()
        let myDateComponents = DateComponents(hour: hour, minute: minute)
        let myDate = calendar.date(from: myDateComponents)
        return myDate ?? Date.init()
    }
    
    static func noon() -> Date {
        let noonDateComponents = DateComponents(hour: 12, minute: 0)
        let myDate = calendar.date(from: noonDateComponents)
        return myDate ?? Date.init()
    }
    
    static func makeAfternoon(time: Date) -> Date {
        return calendar.date(byAdding: .hour, value: -12, to: time)!
    }
}
