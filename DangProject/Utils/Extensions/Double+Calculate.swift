//
//  Calculate+Double.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension Double {
    static func calculateCircleAnimationDuration(dang: Double, maxDang: Double) -> Double {
        return Double((dang/maxDang)*3)
    }
    
    static func calculateSugarSum(todaySugar: [Double]) -> Double {
        var sum: Double = 0.0
        
        for item in todaySugar {
            sum += item
        }
        
        return sum
    }
}
