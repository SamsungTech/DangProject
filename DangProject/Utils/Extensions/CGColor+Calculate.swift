//
//  Calculate+CGColor.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension CGColor {
    static func calculateCircleProgressBarColor(dang: Double,
                                                maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.circleAnimationColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleAnimationColorYellow.cgColor
        } else {
            return UIColor.circleAnimationColorGreen.cgColor
        }
    }
    
    static func calculateCircleProgressBackgroundColor(dang: Double,
                                                       maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.circleBackgroundColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleBackgroundColorYellow.cgColor
        } else {
            return UIColor.circleBackgroundColorGreen.cgColor
        }
    }
    
    static func calculateCirclePercentLineColor(dang: Double,
                                                maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.circleColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleColorYellow.cgColor
        } else {
            return UIColor.circleColorGreen.cgColor
        }
    }
    
    static func calculateColor(dang: Double,
                               maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.smallCircleColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.smallCircleColorYellow.cgColor
        } else {
            return UIColor.smallCircleColorGreen.cgColor
        }
    }
}
