//
//  CalendarUseCaseProtocol.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/04.
//

import Foundation
import UIKit

import RxSwift
import RxRelay

protocol CalendarUseCaseProtocol: AnyObject {
    var currentDay: BehaviorRelay<Int> { get set }
    var currentDateYearMonth: BehaviorRelay<String> { get set }
    var currentLine: PublishSubject<Int> { get set }
    var currentDatePoint: BehaviorRelay<CGPoint> { get set }
    var calendarDataArray: [CalendarEntity] { get set }
    var calendarPreviousMonthData: PublishSubject<CalendarEntity> { get set }
    var calendarNextMonthData: PublishSubject<CalendarEntity> { get set }
    var calendarDataArraySubject: BehaviorRelay<[CalendarEntity]> { get set }
    
    func initCalculationDaysInMonth()
    func createPreviousCalendarData()
    func createNextCalendarData()
    func calculateCurrentMonth()
    func calculateCurrentCellYPoint()
    func calculateCurrentLine(currentDay: Int)
}
