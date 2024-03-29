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
    func twoMonthBeforeData() -> CalendarMonthEntity
    func previousMonthData() -> CalendarMonthEntity
    func currentMonthData() -> CalendarMonthEntity
    func nextMonthData() -> CalendarMonthEntity
    func changeSelectedDate(year: Int, month: Int, day: Int)
    func changeDateComponentsToSelected()
    func changeDateComponentsToCurrent()
}

class DefaultCalendarService: CalendarService {
    var dateComponents = DateComponents()
    private lazy var selectedDateComponents: DateComponents = .currentDateComponents()
    private lazy var calendar: Calendar = {
        var calendar = Calendar.current
        guard let timeZone = TimeZone(identifier: "UTC") else { return Calendar.current }
        calendar.timeZone = timeZone
        return calendar
    }()
    private var selectedDate = Date.currentDate()
    
    init() {
        initDateFormatter()
    }
    private func initDateFormatter() {
        dateComponents.year = calendar.component(.year, from: Date.currentDate())
        dateComponents.month = calendar.component(.month, from: Date.currentDate())
        dateComponents.day = 1
    }
    
    func minusMonth() {
        guard let dateMonth = dateComponents.month,
              let dateYear = dateComponents.year else { return }
        
        if dateMonth - 1 == 0 {
            self.dateComponents.year = dateYear - 1
            self.dateComponents.month = 12
        } else {
            self.dateComponents.month = dateMonth - 1
        }
    }
    
    func plusMonth() {
        guard let dateMonth = dateComponents.month,
              let dateYear = dateComponents.year else { return }
        
        if dateMonth + 1 == 13 {
            self.dateComponents.year = dateYear + 1
            self.dateComponents.month = 1
        } else {
            self.dateComponents.month = dateMonth + 1
        }
    }
    
    func previousMonthData() -> CalendarMonthEntity {
        var previousDateComponents = dateComponents
        guard let previousMonth = previousDateComponents.month else {
            return CalendarMonthEntity.empty
        }
        previousDateComponents.month = previousMonth - 1
        return calculation(dateComponents: previousDateComponents)
    }
    
    func twoMonthBeforeData() -> CalendarMonthEntity {
        var twoMonthBeforeDateComponents = dateComponents
        guard let twoMonthBeforeMonth = dateComponents.month else {
            return CalendarMonthEntity.empty
        }
        twoMonthBeforeDateComponents.month = twoMonthBeforeMonth - 2
        return calculation(dateComponents: twoMonthBeforeDateComponents)
    }
    
    func currentMonthData() -> CalendarMonthEntity {
        return calculation(dateComponents: self.dateComponents)
    }
    
    func nextMonthData() -> CalendarMonthEntity {
        var nextDateComponents = dateComponents
        guard let nextDateMonth = dateComponents.month else {
            return CalendarMonthEntity.empty
        }
        nextDateComponents.month = nextDateMonth + 1
        return calculation(dateComponents: nextDateComponents)
    }
    
    func changeSelectedDate(year: Int, month: Int, day: Int) {
        let newDate = Date.makeDate(year: year, month: month, day: day)
        self.selectedDate = newDate
        self.selectedDateComponents = DateComponents(year: year, month: month, day: 1)
    }
    
    func changeDateComponentsToSelected() {
        self.dateComponents = self.selectedDateComponents
        dateComponents.day = 1
    }
    
    func changeDateComponentsToCurrent() {
        initDateFormatter()
    }
    
    private func calculation(dateComponents: DateComponents) -> CalendarMonthEntity {
        guard let firstDayOfMonth = calendar.date(from: dateComponents),
              let beforeYear = dateComponents.year,
              let beforeMonth = dateComponents.month else { return CalendarMonthEntity.empty }
        
        /// 1: Sunday ~ 7: Saturday
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        /// For indexing
        let weekdayAdding: Int = 2 - firstWeekday
        let beforeMonthsDay: Int = .calculateDaysCount(year: beforeYear, month: beforeMonth-1)
        let days = createDaysArray(weekdayAdding: weekdayAdding,
                                   dateComponents: dateComponents,
                                   beforeMonthsDay: beforeMonthsDay)
        
        let calendarViewModelEntity = CalendarMonthEntity.init(dateComponents: dateComponents, days: days)
        
        return calendarViewModelEntity
    }
    
    private func createDaysArray(weekdayAdding: Int,
                                 dateComponents: DateComponents,
                                 beforeMonthsDay: Int) -> [CalendarDayEntity] {
        var days: [CalendarDayEntity] = []
        guard let yearForCount = dateComponents.year,
              let monthForCount = dateComponents.month else { return [] }
        let daysCountInMonth: Int = .calculateDaysCount(year: yearForCount, month: monthForCount)
        var nextMonthsDay = 1

        for day in weekdayAdding..<42+weekdayAdding {
            var dayEntity: CalendarDayEntity
            
            if day < 1 { // 이전달
                dayEntity = createPreviousCalendarDayEntity(dateComponents: dateComponents,
                                                            day: beforeMonthsDay+day)
                
            } else if day <= daysCountInMonth { // 현재달
                dayEntity = createCurrentCalendarDayEntity(dateComponents: dateComponents,
                                                           day: day)
            } else { // 이후달
                dayEntity = createNextCalendarDayEntity(dateComponents: dateComponents,
                                                        day: nextMonthsDay)
                nextMonthsDay += 1
            }
            days.append(dayEntity)
        }
        
        return days
    }
    
    private func createPreviousCalendarDayEntity(dateComponents: DateComponents,
                                                 day: Int) -> CalendarDayEntity {
        var dayEntity = CalendarDayEntity.empty
        
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return CalendarDayEntity.empty }
        
        dayEntity = CalendarDayEntity.init(year: year,
                                           month: month-1,
                                           day: day)
        dayEntity.isHidden = true
        
        return dayEntity
    }
    
    private func createCurrentCalendarDayEntity(dateComponents: DateComponents,
                                                day: Int) -> CalendarDayEntity {
        var dayEntity = CalendarDayEntity.empty
        
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return CalendarDayEntity.empty }

        dayEntity = CalendarDayEntity.init(year: year,
                                           month: month,
                                           day: day)
        
        if isToday(yearMonth: dateComponents, day: day) {
            dayEntity.isToday = true
        }
        
        if isSelectedDay(yearMonth: dateComponents, day: day) {
            dayEntity.isSelected = true
        }
        
        return dayEntity
    }
    
    private func createNextCalendarDayEntity(dateComponents: DateComponents,
                                             day: Int) -> CalendarDayEntity {
        var dayEntity = CalendarDayEntity.empty
        
        guard let year = dateComponents.year,
              let month = dateComponents.month else { return CalendarDayEntity.empty }

        dayEntity = CalendarDayEntity.init(year: year,
                                           month: month + 1,
                                           day: day)
        dayEntity.isHidden = true
        
        return dayEntity
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
    
    private func isSelectedDay(yearMonth: DateComponents, day: Int) -> Bool {
        let comparingDate: Date = .makeDate(year: yearMonth.year,
                                            month: yearMonth.month,
                                            day: day)
        if comparingDate == selectedDate {
            return true
        }
        return false
    }
}
