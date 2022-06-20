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
        
        if colorCalculateNumber > 66 {
            return UIColor.circleAnimationColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleAnimationColorYellow.cgColor
        } else if colorCalculateNumber > 0 {
            return UIColor.circleAnimationColorGreen.cgColor
        } else {
            return UIColor.circleAnimationColorGray.cgColor
        }
    }
    
    static func calculateCircleProgressBackgroundColor(dang: Double,
                                                       maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 66 {
            return UIColor.circleBackgroundColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleBackgroundColorYellow.cgColor
        } else if colorCalculateNumber > 0{
            return UIColor.circleBackgroundColorGreen.cgColor
        } else {
            return UIColor.circleBackgroundColorGray.cgColor
        }
    }
    
    // MARK: 
    static func calculateCirclePercentLineColor(dang: Double,
                                                maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 66 {
            return UIColor.circleColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.circleColorYellow.cgColor
        } else if colorCalculateNumber > 0 {
            return UIColor.circleColorGreen.cgColor
        } else {
            return UIColor.circleColorGray.cgColor
        }
    }
    
    static func calculateColor(dang: Double,
                               maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 66 {
            return UIColor.smallCircleColorRed.cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.smallCircleColorYellow.cgColor
        } else if colorCalculateNumber > 0 {
            return UIColor.smallCircleColorGreen.cgColor
        } else {
            return UIColor.smallCircleColorGray.cgColor
        }
    }
}
