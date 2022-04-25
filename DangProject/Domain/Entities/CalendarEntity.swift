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
                                   yearMonth: "",
                                   isHiddenArray: [],
                                   dangArray: [],
                                   maxDangArray: [],
                                   isCurrentDayArray: [])
    
    var days: [String]
    var week: [String]
    var yearMonth: String
    var isHiddenArray: [Bool]
    var dangArray: [Double]
    var maxDangArray: [Double]
    var isCurrentDayArray: [Bool]
}
