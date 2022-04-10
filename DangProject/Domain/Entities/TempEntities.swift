//
//  TempData.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation

struct TempNutrient {
    static let empty: Self = .init(dang: "", foodName: "")
    
    var dang: String?
    var foodName: String?
    
    init(dang: String?,
         foodName: String?) {
        self.dang = dang
        self.foodName = foodName
    }
}

struct TodaySugarSum {
    static let empty: Self = .init(todaySum: 0.0)
    
    var todaySum: Double = 0.0
}
