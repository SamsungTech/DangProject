//
//  CalendarCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/01.
//

import Foundation
import RxRelay

struct CalendarCellEntity {
    static let empty: Self = .init(days: "")
    
    var days: String?
    
    init(days: String?) {
        guard let days = days else { return }
        self.days = days
    }
    
}

class CalendarCellViewModel {
    var calendarData = BehaviorRelay<CalendarCellEntity>(value: .empty)
    
    init(calendarData: CalendarCellEntity) {
        self.calendarData.accept(calendarData)
    }
}
