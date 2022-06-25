//
//  CalendarViewModelEntity.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/21.
//
import Foundation
import UIKit

struct CalendarCellViewModelEntity {
    static let empty: Self = .init(calendarDayEntity: CalendarDayEntity.empty,
                            eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel.empty)
    let month: Int
    let day: Int
    var isHidden: Bool
    var isToday: Bool
    var isSelected: Bool
    var totalSugar: Double
    var percentValue: Int
    var layerColor: CGColor
    
    init(calendarDayEntity: CalendarDayEntity,
         eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel) {
        self.month = calendarDayEntity.month
        self.day = calendarDayEntity.day
        self.isHidden = calendarDayEntity.isHidden
        self.isToday = calendarDayEntity.isToday
        self.isSelected = calendarDayEntity.isSelected
        self.totalSugar = {
            var totalSugar: Double = 0
            eatenFoodsPerDayEntity.eatenFoods.forEach{
                totalSugar = totalSugar + (Double($0.amount)*$0.sugar)
            }
            return totalSugar
        }()
        self.percentValue = .calculatePercentValue(dang: self.totalSugar, maxDang: 50)
        self.layerColor = CGColor.calculateCirclePercentLineColor(dang: self.totalSugar, maxDang: 50)
    }
}

struct CalendarDayEntity {
    static let empty: Self = .init(month: 1, day: 1)
    let month: Int
    let day: Int
    var isHidden: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    
    init(month: Int, day: Int) {
        self.month = month
        self.day = day
    }
}

struct CalendarMonthEntity {
    static let empty: Self = .init(dateComponents: DateComponents.init(), days: [])
    var dateComponents: DateComponents
    var days: [CalendarDayEntity]
    
    init(dateComponents: DateComponents, days: [CalendarDayEntity]) {
        self.dateComponents = dateComponents
        self.days = days
    }
}
