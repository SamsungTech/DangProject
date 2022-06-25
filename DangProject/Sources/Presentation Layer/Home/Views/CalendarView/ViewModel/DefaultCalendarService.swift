//
//  DefaultCalendarService.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/21.
//

import Foundation

protocol CalendarService {
    var dateComponents: DateComponents { get }
    func minusMonth()
    func plusMonth()
    func previousMonthData() -> CalendarMonthEntity
    func currentMonthData() -> CalendarMonthEntity
    func nextMonthData() -> CalendarMonthEntity
}
class DefaultCalendarService: CalendarService {
    var dateComponents = DateComponents()
    private lazy var calendar: Calendar = {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()
    private let currentDate = Date.currentDate()
    
    init() {
        initDateFormatter()
    }
    private func initDateFormatter() {
        dateComponents.year = calendar.component(.year, from: currentDate)
        dateComponents.month = calendar.component(.month, from: currentDate)
        dateComponents.day = 1
    }
    
    func minusMonth() {
        self.dateComponents.month! = self.dateComponents.month! - 1
    }
    
    func plusMonth() {
        self.dateComponents.month! = self.dateComponents.month! + 1
    }
    
    func previousMonthData() -> CalendarMonthEntity {
        var previousDateComponents = dateComponents
        previousDateComponents.month! = previousDateComponents.month! - 1
        return calculation(dateComponents: previousDateComponents)
    }
    
    func currentMonthData() -> CalendarMonthEntity {
        return calculation(dateComponents: self.dateComponents)
    }
    
    func nextMonthData() -> CalendarMonthEntity {
        var nextDateComponents = dateComponents
        nextDateComponents.month! = nextDateComponents.month! + 1
        return calculation(dateComponents: nextDateComponents)
    }
    
    private func calculation(dateComponents: DateComponents) -> CalendarMonthEntity {
        
        let firstDayOfMonth = calendar.date(from: dateComponents)
        /// 0: Sunday ~ 7: Saturday
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth!)
        /// For indexing
        let weekdayAdding: Int = 2 - firstWeekday
        let daysCountInMonth: Int = .calculateDaysCount(year: dateComponents.year!, month: dateComponents.month!)
        var days: [CalendarDayEntity] = []
        let beforeMonthsDay: Int = .calculateDaysCount(year: dateComponents.year!, month: dateComponents.month!-1)
        var nextMonthsDay = 1
        for day in weekdayAdding..<42+weekdayAdding {
            var dayEntity: CalendarDayEntity
            if day < 1 { // 이전달
                dayEntity = CalendarDayEntity.init(month: dateComponents.month!-1, day: beforeMonthsDay + day)
                dayEntity.isHidden = true
            } else if day <= daysCountInMonth { // 현재달
                dayEntity = CalendarDayEntity.init(month: dateComponents.month!, day: day)
                if isToday(yearMonth: dateComponents, day: day) {
                    dayEntity.isToday = true
                }
            } else { // 이후달
                dayEntity = CalendarDayEntity.init(month: dateComponents.month! + 1, day: nextMonthsDay)
                dayEntity.isHidden = true
                nextMonthsDay += 1
            }
            days.append(dayEntity)
        }
        
        let calendarViewModelEntity = CalendarMonthEntity.init(dateComponents: dateComponents, days: days)
        
        return calendarViewModelEntity
    }
    
    private func isToday(yearMonth: DateComponents, day: Int) -> Bool {
        let comparingDate: Date = .makeDate(year: yearMonth.year,
                                            month: yearMonth.month,
                                            day: day)
        let currentDate = Date.currentDate()
        if comparingDate == currentDate {
            return true
        }
        return false
    }
}
