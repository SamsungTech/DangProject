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
                                   eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel.empty,
                                   targetSugar: 0)
    let year: Int
    let month: Int
    let day: Int
    var isHidden: Bool
    var isToday: Bool
    var isSelected: Bool
    var totalSugar: Double = 0
    var percentValue: Int = 0
    var layerColor: CGColor = UIColor.circleColorGray.cgColor
    var targetSugar: Int = 0
    
    init(calendarDayEntity: CalendarDayEntity,
         eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel,
         targetSugar: Int) {
        self.targetSugar = targetSugar
        self.year = calendarDayEntity.year
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
        self.percentValue = .calculatePercentValue(dang: self.totalSugar, maxDang: Double(self.targetSugar))
        self.layerColor = CGColor.calculateCirclePercentLineColor(dang: self.totalSugar, maxDang: Double(self.targetSugar))
    }
    
    init(calendarDayEntity: CalendarDayEntity) {
        self.year = calendarDayEntity.year
        self.month = calendarDayEntity.month
        self.day = calendarDayEntity.day
        self.isHidden = calendarDayEntity.isHidden
        self.isToday = calendarDayEntity.isToday
        self.isSelected = calendarDayEntity.isSelected
    }
}

struct CalendarDayEntity {
    static let empty: Self = .init(year: 0, month: 0, day: 0)
    let year: Int
    let month: Int
    let day: Int
    var isHidden: Bool = false
    var isToday: Bool = false
    var isSelected: Bool = false
    
    init(year: Int, month: Int, day: Int) {
        self.year = year
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
