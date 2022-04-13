//
//  DangGeneral.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/09.
//

import Foundation

struct DangGeneral {
    static let empty: Self = .init(tempDang: [],
                                   tempFoodName: [],
                                   weekDang: [],
                                   monthDang: [],
                                   monthMaxDang: [],
                                   yearDang: [])
    
    var tempDang: [String]
    var tempFoodName: [String]
    var weekDang: [String]
    var monthDang: [Double]
    var monthMaxDang: [Double]
    var yearDang: [String]
}
