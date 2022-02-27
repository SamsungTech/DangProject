//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

import Foundation
import RxRelay

struct CalendarStackViewEntity {
    static let empty: Self = .init(calendar: .empty)
    
    var calendar: CalendarEntity?
    
    init(calendar: CalendarEntity?) {
        guard let calendar = calendar else { return }
        self.calendar = calendar
    }
}

class CalendarViewModel {
    var calendarData = BehaviorRelay<CalendarStackViewEntity>(value: .empty)
    
    init(calendarData: CalendarStackViewEntity) {
        self.calendarData.accept(calendarData)
    }
}
