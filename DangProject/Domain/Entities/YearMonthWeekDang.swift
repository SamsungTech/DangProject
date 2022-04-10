//
//  DangYearMonthWeek.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/09.
//

import Foundation

struct YearMonthWeekDang {
    static let empty: Self = .init(dangGeneral: .empty,
                                   todaySugarSum: 0.0)
    
    var tempDang: [String]?
    var tempFoodName: [String]?
    var weekDang: [String]?
    var monthDang: [Double]?
    var monthMaxDang: [Double]?
    var yearDang: [String]?
    var todaySugarSum: Double?
    
    init(dangGeneral: DangGeneral,
         todaySugarSum: Double) {
        self.tempDang = dangGeneral.tempDang
        self.tempFoodName = dangGeneral.tempFoodName
        self.weekDang = dangGeneral.weekDang
        self.monthDang = dangGeneral.monthDang
        self.monthMaxDang = dangGeneral.monthMaxDang
        self.yearDang = dangGeneral.yearDang
    }
}
