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
    
    var daysArray: [String]?
    var daysCount: Int?
    var week: [String]?
    var yearMonth: String?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(calendar: CalendarEntity?) {
        guard let daysArray = calendar?.days,
              let week = calendar?.week,
              let yearMonth = calendar?.yearMouth,
              let isHiddenArray = calendar?.isHiddenArray,
              let dangArray = calendar?.dangArray,
              let maxDangArray = calendar?.maxDangArray,
              let isCurrentDayArray = calendar?.isCurrentDayArray else { return }
        self.daysArray = daysArray
        self.week = week
        self.yearMonth = yearMonth
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}
