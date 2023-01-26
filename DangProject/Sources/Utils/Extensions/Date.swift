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
    
    static func dateComponentsToDate(_ dateComponents: DateComponents) -> Date {
        guard let result = calendar.date(from: dateComponents) else { return Date() }
        return result
    }
    
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
        let dateString = "\(hour):\(minute)"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.date(from: dateString) ?? Date.init()
    }
    
    static func stringToDate(amPm: String, time: String) -> Date {
        let dateString = "\(amPm) \(time)"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        return dateFormatter.date(from: dateString) ?? Date.init()
    }
}
