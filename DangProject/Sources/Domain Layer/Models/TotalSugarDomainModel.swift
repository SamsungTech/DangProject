
//
//  TotalSugarDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/08/22.
//

import Foundation

struct TotalSugarPerDayDomainModel {
    var date: Date
    var totalSugar: Double
    
    init(date: Date, totalSugar: Double) {
        self.date = date
        self.totalSugar = totalSugar
    }
}

struct TotalSugarPerMonthDomainModel {
    static let empty: Self = .init(month: DateComponents.init(), totalSugarPerMonth: [])
    var month: DateComponents
    var totalSugarPerMonth: [TotalSugarPerDayDomainModel]
    
    init(month: DateComponents, totalSugarPerMonth: [TotalSugarPerDayDomainModel]) {
        self.month = month
        self.totalSugarPerMonth = totalSugarPerMonth
    }
}
