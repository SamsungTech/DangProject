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
                                   yearMouth: "")
    
    var days: [String]?
    var daysCount: Int?
    var weeks: [String]?
    var yearMouth: String?
    
    init(days: [String]?,
         daysCount: Int?,
         weeks: [String]?,
         yearMouth: String?) {
        self.days = days
        self.daysCount = daysCount
        self.weeks = weeks
        self.yearMouth = yearMouth
    }
}
