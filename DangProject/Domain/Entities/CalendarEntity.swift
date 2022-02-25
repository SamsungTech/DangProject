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
                                   lineNumber: 0)
    
    var days: [String]?
    var daysCount: Int?
    var weeks: [String]?
    var yearMouth: String?
    var lineNumber: Int?
    
    init(days: [String]?,
         daysCount: Int?,
         weeks: [String]?,
         yearMouth: String?,
         lineNumber: Int?) {
        self.days = days
        self.daysCount = daysCount
        self.weeks = weeks
        self.yearMouth = yearMouth
        self.lineNumber = lineNumber
    }
}
