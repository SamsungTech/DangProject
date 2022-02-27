//
//  CalendarUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/20.
//

import Foundation
import UIKit
import RxSwift

class CalendarUseCase {
    private let currentDate = Date()
    private var calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    private var dateComponents = DateComponents()
    private var weeks: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    private var days: [String] = []
    private var daysCount = 0
    private var startDay = 0
    private var yearMonth = ""
    
    private var animationLineNumber = 0
    
    private var calendarDataArray: [CalendarEntity] = []
    
    private var yearNumber = 0
    
    private var plusNumber = 1
    private var plusMonthSumData = 0
    private var plusMonthNumber = 0
    
    private var minusNumber = -1
    private var minusMonthSumData = 0
    private var minusMonthNumber = 0
    
    private var isYearNumberChange = false
    
    private func initDateFormatter() {
        dateFormatter.dateFormat = "yyyy년 M월"
        dateComponents.year = calendar.component(.year, from: currentDate)
        dateComponents.month = calendar.component(.month, from: currentDate)
        dateComponents.day = 1
    }
    
    private func calculateMouthCalendar() {
        if let firstDay = calendar.date(from: dateComponents) {
            let firstWeekDay = calendar.component(.weekday, from: firstDay)
            daysCount = calendar.range(of: .day, in: .month, for: firstDay)?.count ?? 0
            startDay = 2 - firstWeekDay
            yearMonth = dateFormatter.string(from: firstDay)
        }
        
        self.days.removeAll()
        for day in startDay...daysCount {
            if day < 1 {
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    func calculationDaysInMouth() -> Observable<[CalendarEntity]> {
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
        calculateMouthCalendar()
        appendCalendarDataArray()
        calculateCurrentCellYPoint()
    }
    
    private func calculatePreviousMouth() {
        initDateFormatter()
        minusMonthSumData = dateComponents.month! + minusNumber
        dateComponents.month = minusMonthSumData
        
        if minusMonthSumData == 0 {
            setupPreviousCalculationsSameValue()
        } else if minusMonthSumData < 0 {
            setupPreviousYearCalculationLargeValue()
        } else {
            setupPreviousMouthNormally()
        }
    }
    
    private func setupPreviousCalculationsSameValue() {
        yearNumber -= 1
        dateComponents.year = dateComponents.year! + yearNumber
        dateComponents.month = 12
        calculateMouthCalendar()
        isYearNumberChange = true
        print("Previous month", minusMonthSumData)
    }
    
    private func setupPreviousYearCalculationLargeValue() {
        minusMonthNumber -= 1
        dateComponents.year = dateComponents.year! + yearNumber
        dateComponents.month = 12
        dateComponents.month = dateComponents.month! + minusMonthNumber
        calculateMouthCalendar()
        print("Previous month", minusMonthSumData)
    }
    
    private func setupPreviousMouthNormally() {
        if isYearNumberChange == true { yearNumber -= 1 }
        dateComponents.month = minusMonthSumData
        print("Previous month", minusMonthSumData)
        calculateMouthCalendar()
        isYearNumberChange = false
    }
    
    private func calculateNextMouth() {
        initDateFormatter()
        plusMonthSumData = dateComponents.month! + plusNumber
        dateComponents.month = plusMonthSumData
        
        if plusMonthSumData == 13 {
            setupNextYearCalculationsSameValue()
        } else if plusMonthSumData > 13 {
            setupNextYearCalculationLargeValue()
        } else {
            setupNextMouthNormally()
        }
    }
    
    private func setupNextYearCalculationsSameValue() {
        yearNumber += 1
        dateComponents.year = dateComponents.year! + yearNumber
        dateComponents.month = 1
        calculateMouthCalendar()
        isYearNumberChange = true
        print("next month", plusMonthSumData)
    }
    
    private func setupNextYearCalculationLargeValue() {
        plusMonthNumber += 1
        dateComponents.year = dateComponents.year! + yearNumber
        dateComponents.month = 1
        dateComponents.month = dateComponents.month! + plusMonthNumber // MARK: 이게 0으로 되는 순간
        calculateMouthCalendar()
        print("next month", plusMonthSumData)
    }
    
    private func setupNextMouthNormally() {
        if isYearNumberChange == true { yearNumber += 1 }
        dateComponents.month = plusMonthSumData
        print("next month", plusMonthSumData)
        calculateMouthCalendar()
        isYearNumberChange = false
    }
    
    private func appendCalendarDataArray() {
        calendarDataArray.append(
            CalendarEntity(days: self.days,
                           daysCount: self.daysCount,
                           weeks: self.weeks,
                           yearMouth: self.yearMonth,
                           lineNumber: self.animationLineNumber)
        )
    }
    
    // MARK: Rename
    func leftSwipe() -> Observable<[CalendarEntity]> {
        minusNumber -= 1
        plusNumber -= 1
        calendarDataArray.removeLast()
        calculatePreviousMouth()
        calendarDataArray.insert(CalendarEntity(days: self.days,
                                                daysCount: self.daysCount,
                                                weeks: self.weeks,
                                                yearMouth: self.yearMonth,
                                                lineNumber: self.animationLineNumber), at: 0)
        print("left CalendarDataArray","\n",
              calendarDataArray[0].yearMouth ?? "","\n",
              calendarDataArray[1].yearMouth ?? "","\n",
              calendarDataArray[2].yearMouth ?? "")
        return Observable.create { [weak self] (observer) -> Disposable in
            observer.onNext(self?.calendarDataArray ?? [])
            observer.onCompleted()
            return Disposables.create()
        }

    }
    
    // MARK: Rename
    func rightSwipe() -> Observable<[CalendarEntity]> {
        plusNumber += 1
        minusNumber += 1
        calendarDataArray.removeFirst()
        calculateNextMouth()
        calendarDataArray.insert(CalendarEntity(days: self.days,
                                                daysCount: self.daysCount,
                                                weeks: self.weeks,
                                                yearMouth: self.yearMonth,
                                                lineNumber: self.animationLineNumber), at: 2)
        print("right CalendarDataArray","\n",
              calendarDataArray[0].yearMouth ?? "","\n",
              calendarDataArray[1].yearMouth ?? "","\n",
              calendarDataArray[2].yearMouth ?? "")
        return Observable.create { [weak self] (observer) -> Disposable in
            observer.onNext(self?.calendarDataArray ?? [])
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

extension CalendarUseCase {
    private func calculateCurrentCellYPoint() {
        if days.first == "" {
            let startEmpty = abs(startDay - 1)
            let currentDay = calendar.component(.day, from: currentDate) + startEmpty
            animationLineNumber = calculateCurrentLine(currentDay: currentDay)
        } else {
            let currentDay = calendar.component(.day, from: currentDate)
            animationLineNumber = calculateCurrentLine(currentDay: currentDay)
        }
    }
    
    private func calculateCurrentLine(currentDay: Int) -> Int {
        switch abs(currentDay/7) {
        case 0:
            print("첫번째 줄")
            return 1
        case 1:
            print("두번째 줄")
            return 2
        case 2:
            print("세번째 줄")
            return 3
        case 3:
            print("네번째 줄")
            return 4
        default:
            print("다섯번째 줄")
            return 5
        }
    }
}
