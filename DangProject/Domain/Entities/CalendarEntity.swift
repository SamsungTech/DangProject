//
//  CalendarEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/20.
//

import Foundation

struct CalendarEntity: Equatable {
    static let empty: Self = .init(days: [],
                                   week: [],
                                   yearMouth: "",
                                   isHiddenArray: [],
                                   dangArray: [],
                                   maxDangArray: [],
                                   isCurrentDayArray: [])
    
    var days: [String]?
    var week: [String]?
    var yearMouth: String?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(days: [String]?,
         week: [String]?,
         yearMouth: String?,
         isHiddenArray: [Bool]?,
         dangArray: [Double]?,
         maxDangArray: [Double]?,
         isCurrentDayArray: [Bool]?) {
        self.days = days
        self.week = week
        self.yearMouth = yearMouth
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}
