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
        let result = abs(dangValueNumber)
        let num = Swift.min(result, 100.0)
        
        if num.isNaN {
            return 0
        }
        
        return Int(num)
    }

    static func calculateDaysCount(year: Int, month: Int) -> Int {
        let date = Date.makeDate(year: year, month: month, day: 1)
        guard let calendarRange = Calendar.current.range(of: .day, in: .month, for: date)?.count else { return 0 } // 해당 월의 일수 계산
        return calendarRange
    }
}
