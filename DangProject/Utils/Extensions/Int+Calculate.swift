//
//  Calculate+Int.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension Int {
    static func calculatePercentValue(dang: Double,
                                      maxDang: Double) -> Int {
        let dangValueNumber: Double = (dang/maxDang)*Double(100)
        let division: Double = 100*(dangValueNumber/100)
        let result = abs(division)
        
        return Int(result)
    }
}
