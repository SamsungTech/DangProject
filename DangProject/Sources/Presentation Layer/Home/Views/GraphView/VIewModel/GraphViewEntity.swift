//
//  GraphViewEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/10.
//

import Foundation

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
