//
//  BatteryCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/16.
//

import Foundation
import RxRelay
import RxSwift

enum ScrollDirection {
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
