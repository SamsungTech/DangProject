//
//  CalendarEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/20.
//

import Foundation

struct CalendarEntity {
    static let empty: Self = .init(days: [],
                                   daysCount: 0,
                                   weeks: [],
                                   yearMouth: "",
                                   isHiddenArray: [],
                                   dangArray: [],
                                   maxDangArray: [],
                                   isCurrentDayArray: [])
    
    var days: [String]?
    var daysCount: Int?
    var weeks: [String]?
    var yearMouth: String?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(days: [String]?,
         daysCount: Int?,
         weeks: [String]?,
         yearMouth: String?,
         isHiddenArray: [Bool]?,
         dangArray: [Double]?,
         maxDangArray: [Double]?,
         isCurrentDayArray: [Bool]?) {
        self.days = days
        self.daysCount = daysCount
        self.weeks = weeks
        self.yearMouth = yearMouth
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}
