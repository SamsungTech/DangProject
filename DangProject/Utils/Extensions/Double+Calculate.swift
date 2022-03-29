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
}
