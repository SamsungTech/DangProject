//
//  BatteryCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/16.
//

import Foundation
import RxRelay
import RxSwift

struct BatteryEntity {
    static let empty: Self = .init(calendar: .empty)
    
    var days: [String]?
    var daysCount: Int?
    var week: [String]?
    var yearMouth: String?
    var lineNumber: Int?
    
    init(calendar: CalendarEntity) {
        guard let days = calendar.days,
              let daysCount = calendar.daysCount,
              let week = calendar.weeks,
              let yearMouth = calendar.yearMouth else { return }
        self.days = days
        self.daysCount = daysCount
        self.week = week
        self.yearMouth = yearMouth
    }
}

class BatteryCellViewModel {
    private var useCase: CalendarUseCase?
    var items = BehaviorRelay<sugarSum>(value: .empty)
    var batteryData = BehaviorRelay<BatteryEntity>(value: .empty)
    
    init(item: sugarSum) {
        self.items.accept(item)
    }
    init(batteryData: BatteryEntity) {
        self.batteryData.accept(batteryData)
    }
}

extension BatteryCellViewModel {
    
}
