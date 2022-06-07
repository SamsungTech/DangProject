//
//  Calculate+CGFloat.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension CGFloat {
    static func calculateRevertAnimationYValue(value: Int) -> CGFloat {
        switch value {
        case 0:
            return UIScreen.main.bounds.maxY*((CGFloat(110))/844)
        case 1:
            return UIScreen.main.bounds.maxY*((CGFloat(3))/844)
        case 2:
            return -(UIScreen.main.bounds.maxY*((CGFloat(57))/844))
        case 3:
            return -(UIScreen.main.bounds.maxY*((CGFloat(117))/844))
        case 4:
            return -(UIScreen.main.bounds.maxY*((CGFloat(177))/844))
        case 5:
            return -(UIScreen.main.bounds.maxY*((CGFloat(237))/844))
        default:
            return -(UIScreen.main.bounds.maxY*((CGFloat(297))/844))
        }
    }
    
    static func calculateMonthDangDataNumber(dang: Double,
                                             maxDang: Double) -> CGFloat {
        let dangValueNumber: Double = (dang/maxDang)*Double(80)
        let number3: Double = 80*(dangValueNumber/80)
        let result: Double = number3/100
        
        return CGFloat(result)
    }
}
