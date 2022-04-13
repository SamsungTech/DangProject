//
//  MonthDangEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/10.
//

import Foundation

struct MonthDangEntity {
    static let empty: Self = .init(dang: [],
                                   maxDang: [])
    
    var dang: [Double]?
    var maxDang: [Double]?
    
    init(dang: [Double]?,
         maxDang: [Double]?) {
        self.dang = dang
        self.maxDang = maxDang
    }
}
