//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

import Foundation
import RxRelay

struct SelectedCalendarCellEntity {
    static let empty: Self = .init(yearMonth: "",
                                   indexPath: IndexPath(item: 0, section: 0))
    
    var yearMonth: String?
    var indexPath: IndexPath?
    
    init(yearMonth: String, indexPath: IndexPath) {
        self.yearMonth = yearMonth
        self.indexPath = indexPath
    }
}

struct CalendarMonthDangEntity {
    static let empty: Self = .init(calendarMonthDang: [])
    
    var calendarMonthDang: [MonthDangEntity]?
    
    init(calendarMonthDang: [MonthDangEntity]?) {
        self.calendarMonthDang = calendarMonthDang
    }
}

struct CalendarStackViewEntity {
    static let empty: Self = .init(batteryEntity: .empty)
    
    var yearMonth: String?
    var daysArray: [String]?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(batteryEntity: BatteryEntity?) {
        guard let yearMonth = batteryEntity?.yearMonth,
              let daysArray = batteryEntity?.daysArray,
              let isHiddenArray = batteryEntity?.isHiddenArray,
              let dangArray = batteryEntity?.dangArray,
              let maxDangArray = batteryEntity?.maxDangArray,
              let isCurrentDayArray = batteryEntity?.isCurrentDayArray else { return }
        self.yearMonth = yearMonth
        self.daysArray = daysArray
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}

class CalendarViewModel {
    var calendarData = BehaviorRelay<CalendarStackViewEntity>(value: .empty)
    var selectedCellIndexPath = BehaviorRelay<IndexPath>(value: IndexPath(item: 0, section: 0))
    
    init(calendarData: BatteryEntity) {
        self.calendarData.accept(CalendarStackViewEntity(batteryEntity: calendarData))
    }
}
