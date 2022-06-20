//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

struct GraphViewEntity {
    static let empty: Self = .init(weekDang: [],
                                   monthDang: [],
                                   yearDang: [])
    var weekDang: [String]?
    var monthDang: [Double]?
    var yearDang: [String]?
    
    init(weekDang: [String],
         monthDang: [Double],
         yearDang: [String]) {
        self.weekDang = weekDang
        self.monthDang = monthDang
        self.yearDang = yearDang
    }
}

class GraphViewModel {
    var items = BehaviorRelay<GraphViewEntity>(value: .empty)
    
    init(item: GraphViewEntity) {
        self.items.accept(item)
    }
}
