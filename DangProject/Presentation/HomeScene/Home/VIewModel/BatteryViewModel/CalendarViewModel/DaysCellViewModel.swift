//
//  CalendarCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/01.
//

import Foundation

import RxRelay
import RxSwift


struct DaysCellEntity {
    static let empty: Self = .init(yearMonth: "",
                                   days: String(),
                                   isHidden: Bool(),
                                   dang: Double(),
                                   maxDang: Double(),
                                   isCurrentDay: Bool())
    var yearMonth: String
    var days: String
    var isHidden: Bool
    var dang: Double
    var maxDang: Double
    var isCurrentDay: Bool
}

extension DaysCellEntity {
    init(calendarStackViewEntity: CalendarStackViewEntity,
         indexPathItem: Int) {
        self.yearMonth = calendarStackViewEntity.yearMonth
        self.days = calendarStackViewEntity.daysArray[indexPathItem]
        self.isHidden = calendarStackViewEntity.isHiddenArray[indexPathItem]
        self.dang = calendarStackViewEntity.dangArray[indexPathItem]
        self.maxDang = calendarStackViewEntity.maxDangArray[indexPathItem]
        self.isCurrentDay = calendarStackViewEntity.isCurrentDayArray[indexPathItem]
    }
}

protocol DaysCellViewModelInputProtocol: AnyObject {}

protocol DaysCellViewModelOutputProtocol: AnyObject {
    var yearMonth: BehaviorRelay<String> { get }
    var days: BehaviorRelay<String> { get }
    var isHidden: BehaviorRelay<Bool> { get }
    var circleColor: BehaviorRelay<CGColor> { get }
    var circleNumber: BehaviorRelay<CGFloat> { get }
    var isCurrentDay: BehaviorRelay<Bool> { get }
}

protocol DaysCellViewModelProtocol: DaysCellViewModelInputProtocol, DaysCellViewModelOutputProtocol {}

class DaysCellViewModel: DaysCellViewModelProtocol {
    var yearMonth = BehaviorRelay<String>(value: "")
    var days = BehaviorRelay<String>(value: "")
    var isHidden = BehaviorRelay<Bool>(value: Bool())
    var circleColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var circleNumber = BehaviorRelay<CGFloat>(value: CGFloat())
    var isCurrentDay = BehaviorRelay<Bool>(value: Bool())
    
    init(daysCellData: DaysCellEntity) {
        self.yearMonth.accept(
            daysCellData.yearMonth
        )
        self.days.accept(
            daysCellData.days
        )
        self.isHidden.accept(
            daysCellData.isHidden
        )
        self.circleColor.accept(
            .calculateColor(
                dang: daysCellData.dang,
                maxDang: daysCellData.maxDang
            )
        )
        self.circleNumber.accept(
            .calculateMonthDangDataNumber(
                dang: daysCellData.dang,
                maxDang: daysCellData.maxDang
            )
        )
        self.isCurrentDay.accept(
            daysCellData.isCurrentDay
        )
    }
}
