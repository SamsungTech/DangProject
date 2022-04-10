//
//  MockCalendarUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/06.
//

import Foundation

import RxSwift
import RxRelay

class MockCalendarUseCase: CalendarUseCaseProtocol {
    var currentDay: BehaviorRelay<Int>
    var currentDateYearMonth: BehaviorRelay<String>
    var currentLine: PublishSubject<Int>
    var currentDatePoint: BehaviorRelay<CGPoint>
    var calendarDataArray: [CalendarEntity]
    var calendarPreviousMonthData: PublishSubject<CalendarEntity>
    var calendarNextMonthData: PublishSubject<CalendarEntity>
    var calendarDataArraySubject: BehaviorRelay<[CalendarEntity]>
    
    init() {
        self.currentDay = BehaviorRelay<Int>(value: 0)
        self.currentDateYearMonth = BehaviorRelay<String>(value: "")
        self.currentLine = PublishSubject<Int>()
        self.currentDatePoint = BehaviorRelay<CGPoint>(value: .zero)
        self.calendarDataArray = [CalendarEntity.empty]
        self.calendarPreviousMonthData = PublishSubject<CalendarEntity>()
        self.calendarNextMonthData = PublishSubject<CalendarEntity>()
        self.calendarDataArraySubject = BehaviorRelay<[CalendarEntity]>(value: [])
    }
    
    func initCalculationDaysInMonth() {
        calendarDataArraySubject.accept(self.calendarDataArray)
    }
    
    func createPreviousCalendarData() {
        let calendarEntity = CalendarEntity(days: ["1"],
                                            week: ["월"],
                                            yearMonth: "2월",
                                            isHiddenArray: [true],
                                            dangArray: [1.1],
                                            maxDangArray: [1.1],
                                            isCurrentDayArray: [false])
        calendarPreviousMonthData.onNext(calendarEntity)
    }
    
    func createNextCalendarData() {
        let calendarEntity = CalendarEntity(days: ["1"],
                                            week: ["월"],
                                            yearMonth: "6월",
                                            isHiddenArray: [true],
                                            dangArray: [1.1],
                                            maxDangArray: [1.1],
                                            isCurrentDayArray: [false])
        calendarNextMonthData.onNext(calendarEntity)
    }
    
    func calculateCurrentCellYPoint() {
        calculateCurrentLine(currentDay: 12)
    }
    
    func calculateCurrentMonth() {}
    
    func calculateCurrentLine(currentDay: Int) {
        switch abs(currentDay/7) {
        case 0:
            currentLine.onNext(0)
        case 1:
            currentLine.onNext(1)
        case 2:
            currentLine.onNext(2)
        case 3:
            currentLine.onNext(3)
        case 4:
            currentLine.onNext(4)
        default:
            currentLine.onNext(5)
        }
    }
}
