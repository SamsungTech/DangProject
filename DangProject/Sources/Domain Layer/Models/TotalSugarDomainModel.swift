
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
    var month: Int
    var totalSugarPerMonth: [TotalSugarPerDayDomainModel]
    
    init(month: Int, totalSugarPerMonth: [TotalSugarPerDayDomainModel]) {
        self.month = month
        self.totalSugarPerMonth = totalSugarPerMonth
    }
}
