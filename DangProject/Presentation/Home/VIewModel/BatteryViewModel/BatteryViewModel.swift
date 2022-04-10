//
//  BatteryCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/16.
//

import Foundation
import RxRelay
import RxSwift
import UIKit


struct BatteryEntity {
    static let empty: Self = .init(calendar: .empty)
    
    var daysArray: [String]
    var week: [String]
    var yearMonth: String
    var isHiddenArray: [Bool]
    var dangArray: [Double]
    var maxDangArray: [Double]
    var isCurrentDayArray: [Bool]
}

extension BatteryEntity {
    init(calendar: CalendarEntity) {
        self.daysArray = calendar.days
        self.week = calendar.week
        self.yearMonth = calendar.yearMonth
        self.isHiddenArray = calendar.isHiddenArray
        self.dangArray = calendar.dangArray
        self.maxDangArray = calendar.maxDangArray
        self.isCurrentDayArray = calendar.isCurrentDayArray
    }
}
