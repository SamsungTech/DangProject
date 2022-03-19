//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

import Foundation
import RxRelay

struct CalendarMonthDangEntity {
    static let empty: Self = .init(calendarMonthDang: [])
    
    var calendarMonthDang: [MonthDangEntity]?
    
    init(calendarMonthDang: [MonthDangEntity]?) {
        self.calendarMonthDang = calendarMonthDang
    }
}

struct CalendarStackViewEntity {
    static let empty: Self = .init(batteryEntity: .empty)
    
    var daysArray: [String]?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(batteryEntity: BatteryEntity?) {
        guard let daysArray = batteryEntity?.daysArray,
              let isHiddenArray = batteryEntity?.isHiddenArray,
              let dangArray = batteryEntity?.dangArray,
              let maxDangArray = batteryEntity?.maxDangArray,
              let isCurrentDayArray = batteryEntity?.isCurrentDayArray else { return }
        self.daysArray = daysArray
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}

class CalendarViewModel {
    var calendarData = BehaviorRelay<CalendarStackViewEntity>(value: .empty)
    
    init(calendarData: BatteryEntity) {
        self.calendarData.accept(CalendarStackViewEntity(batteryEntity: calendarData))
    }
}
