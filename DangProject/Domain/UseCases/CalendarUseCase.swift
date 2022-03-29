//
//  CalendarUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/20.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class CalendarUseCase {
    private var repository: HomeRepository?
    private let currentDate = Date()
    private var calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var dateComponents = DateComponents()
    private var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private var days: [String] = []
    private var daysCount = 0
    private var startDay = 0
    private var startEmptyCount = 0
    private var yearMonth = ""
    private var animationLineNumber = 0
    private var plusNumber: Int = 1
    private var minusNumber: Int = -1
    private var calendarDataArray: [CalendarEntity] = []
    private var isCurrentDayArray: [Bool] = []
    
    var currentDay = BehaviorRelay<Int>(value: 0)
    var currentDateYearMonth = BehaviorRelay<String>(value: "")
    var currentLine = BehaviorRelay<Int>(value: 0)
    var currentDatePoint = BehaviorRelay<CGPoint>(value: CGPoint())
    var isHiddenArray: [Bool] = []
    
    init(repository: HomeRepository) {
        self.repository = repository
    }
    
    private func initDateFormatter() {
        dateFormatter.dateFormat = "yyyy년 M월"
        dateComponents.year = calendar.component(.year, from: currentDate)
        dateComponents.month = calendar.component(.month, from: currentDate)
        dateComponents.day = 1
    }
    
    private func calculateMouthCalendar() {
        guard let calculateMonth = dateComponents.month else { return }
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        if let firstDay = calendar.date(from: dateComponents) {
            let firstWeekDay = calendar.component(.weekday, from: firstDay)
            guard let calendarRange = calendar.range(of: .day, in: .month, for: firstDay)?.count else { return }
            daysCount = calendarRange
            startDay = 2 - firstWeekDay
            yearMonth = dateFormatter.string(from: firstDay)
        }
        
        for day in 1...daysCount {
            self.days.append(String(day))
            isHiddenArray.append(false)
            calculateCurrentMonthDay(currentMonth: currentMonth,
                                     calculateMonth: calculateMonth,
                                     day: day,
                                     currentDay: currentDay)
        }
    }
    
    private func calculateCurrentMonthDay(currentMonth: Int,
                                          calculateMonth: Int,
                                          day: Int,
                                          currentDay: Int) {
        if currentMonth == calculateMonth && day == currentDay {
            isCurrentDayArray.append(true)
            self.currentDay.accept(isCurrentDayArray.count-1)
        } else {
            isCurrentDayArray.append(false)
        }
    }
    
    private func calculateEmptyFirstDay() {
        if let firstDay = calendar.date(from: dateComponents) {
            let firstWeekDay = calendar.component(.weekday, from: firstDay)
            guard let calendarRange = calendar.range(of: .day, in: .month, for: firstDay)?.count else { return }
            daysCount = calendarRange
            startDay = firstWeekDay - 1
            yearMonth = dateFormatter.string(from: firstDay)
        }
    }
    
    private func calculatePreviousMonthEmptyData() {
        dateComponents.month = dateComponents.month! - 1
        calculateEmptyFirstDay()
        self.days.removeAll()
        
        var previousMonthData: [String] = []
        
        for i in 1...daysCount {
            previousMonthData.append(String(i))
        }
        
        dateComponents.month = dateComponents.month! + 1
        calculateEmptyFirstDay()
        self.days.removeAll()
        let emptyCount = previousMonthData.count - startDay
        
        if emptyCount != previousMonthData.count {
            for i in emptyCount..<previousMonthData.count {
                days.append(previousMonthData[i])
                isHiddenArray.append(true)
                isCurrentDayArray.append(false)
            }
        }
        
        if let firstDay = calendar.date(from: dateComponents) {
            yearMonth = dateFormatter.string(from: firstDay)
        }
        
    }
    
    private func calculateNextMonthEmptyData() {
        dateComponents.month = dateComponents.month! + 1
        let backEmptyCount = 42 - days.count
        calculateEmptyFirstDay()
        
        var nextMonthData: [String] = []
        
        for i in 1...daysCount {
            nextMonthData.append(String(i))
        }
        
        for i in 0..<backEmptyCount {
            self.days.append(nextMonthData[i])
            self.isHiddenArray.append(true)
            isCurrentDayArray.append(false)
        }
        
        dateComponents.month = dateComponents.month! - 1
        
        if let firstDay = calendar.date(from: dateComponents) {
            yearMonth = dateFormatter.string(from: firstDay)
        }
    }
    
    func initCalculationDaysInMouth() -> Observable<[CalendarEntity]> {
        calendarDataArray.removeAll()
        calculatePreviousMouth()
        appendCalendarDataArray()
        calculateCurrentMouth()
        calculateNextMouth()
        appendCalendarDataArray()
        return Observable.create { [weak self] (observer) -> Disposable in
            observer.onNext(self?.calendarDataArray ?? [])
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    private func calculateCurrentMouth() {
        initDateFormatter()
        calculatePreviousMonthEmptyData()
        startEmptyCount = days.count
        calculateMouthCalendar()
        calculateNextMonthEmptyData()
        currentDateYearMonth.accept(yearMonth)
        appendCalendarDataArray()
        calculateCurrentCellYPoint()    }
    
    private func calculatePreviousMouth() {
        initDateFormatter()
        let minusMonthSumData = dateComponents.month! + minusNumber
        dateComponents.month = minusMonthSumData
        calculatePreviousMonthEmptyData()
        calculateMouthCalendar()
        calculateNextMonthEmptyData()
    }
    
    private func calculateNextMouth() {
        initDateFormatter()
        let plusMonthSumData = dateComponents.month! + plusNumber
        dateComponents.month = plusMonthSumData
        calculatePreviousMonthEmptyData()
        calculateMouthCalendar()
        calculateNextMonthEmptyData()
    }
    
    private func appendCalendarDataArray() {
        calendarDataArray.append(
            CalendarEntity(days: self.days,
                           daysCount: self.daysCount,
                           weeks: self.weeks,
                           yearMouth: self.yearMonth,
                           isHiddenArray: self.isHiddenArray,
                           dangArray: self.repository?.monthData[0].dang,
                           maxDangArray: self.repository?.monthData[0].maxDang,
                           isCurrentDayArray: self.isCurrentDayArray)
        )
        isCurrentDayArray.removeAll()
        isHiddenArray.removeAll()
    }
    
    func createPreviousCalendarData() -> Observable<CalendarEntity> {
        minusNumber -= 1
        calculatePreviousMouth()
        let calendarEntity = CalendarEntity(days: self.days,
                                            daysCount: self.daysCount,
                                            weeks: self.weeks,
                                            yearMouth: self.yearMonth,
                                            isHiddenArray: self.isHiddenArray,
                                            dangArray: self.repository?.monthData[0].dang,
                                            maxDangArray: self.repository?.monthData[0].maxDang,
                                            isCurrentDayArray: self.isCurrentDayArray)
        isCurrentDayArray.removeAll()
        isHiddenArray.removeAll()
        return Observable.create { (observer) -> Disposable in
            observer.onNext(calendarEntity)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func createNextCalendarData() -> Observable<CalendarEntity> {
        plusNumber += 1
        calculateNextMouth()
        let calendarEntity = CalendarEntity(days: self.days,
                                            daysCount: self.daysCount,
                                            weeks: self.weeks,
                                            yearMouth: self.yearMonth,
                                            isHiddenArray: self.isHiddenArray,
                                            dangArray: self.repository?.monthData[0].dang,
                                            maxDangArray: self.repository?.monthData[0].maxDang,
                                            isCurrentDayArray: self.isCurrentDayArray)
        isCurrentDayArray.removeAll()
        isHiddenArray.removeAll()
        return Observable.create { (observer) -> Disposable in
            observer.onNext(calendarEntity)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension CalendarUseCase {
    func calculateCurrentCellYPoint() {
        let currentDayCount = calendar.component(.day, from: currentDate) + startEmptyCount
        currentDay.accept(currentDayCount)
        calculateCurrentLine(currentDay: currentDayCount)
    }
    
    func calculateCurrentLine(currentDay: Int) {
        switch abs(currentDay/7) {
        case 0:
            currentLine.accept(0)
        case 1:
            currentLine.accept(1)
        case 2:
            currentLine.accept(2)
        case 3:
            currentLine.accept(3)
        case 4:
            currentLine.accept(4)
        default:
            currentLine.accept(5)
        }
    }
}
