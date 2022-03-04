//
//  BatteryCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/16.
//

import Foundation
import RxRelay
import RxSwift

enum ScrollDiection {
    case right
    case center
    case left
}

struct BatteryEntity {
    static let empty: Self = .init(calendar: [])
    
    var calendar: [CalendarEntity]?
    
    init(calendar: [CalendarEntity]?) {
        guard let calendar = calendar else { return }
        self.calendar = calendar
    }
}

class BatteryViewModel {
    var items = BehaviorRelay<sugarSum>(value: .empty)
    var batteryData = BehaviorRelay<BatteryEntity>(value: .empty)
    
    init(item: sugarSum) {
        self.items.accept(item)
    }
    init(batteryData: BatteryEntity) {
        self.batteryData.accept(batteryData)
    }
}
