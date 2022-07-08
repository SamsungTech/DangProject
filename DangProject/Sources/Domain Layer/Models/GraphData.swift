//
//  GraphData.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/06.
//

import Foundation

struct GraphData {
    static let empty: Self = .init(yearArray: [], monthArray: [], dayArray: [])
    var yearArray: [String]
    var monthArray: [String]
    var dayArray: [String]
}
