//
//  Extensions.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit
import Then

extension UIView {
    func viewRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func xValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxX*(value/390)
    }
    
    func yValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxY*(value/844)
    }
}

extension UIViewController {
    func xValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxX*(value/390)
    }
    
    func yValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxY*(value/844)
    }
    
    func overSizeYValueRatio(_ value: CGFloat) -> CGFloat {
        let value = Int(value)
        let divisionValue = value / 500
        let remainder = value % 500
        
        return CGFloat((500*divisionValue) + remainder)
    }
}

enum CustomHomeColorType {
    case homeBackgroundColor
    case homeBoxColor
}

enum CustomCircleColorType {
    case circleColorGreen
    case circleColorYellow
    case circleColorRed
}

enum CustomCircleAnimationColorType {
    case circleAnimationColorGreen
    case circleAnimationColorYellow
    case circleAnimationColorRed
}

enum CustomCircleBackgroundColorType {
    case circleBackgroundColorGreen
    case circleBackgroundColorYellow
    case circleBackgroundColorRed
}

enum CustomSmallCircleColorType {
    case smallCircleColorGreen
    case smallCircleColorYellow
    case smallCircleColorRed
}

enum CustomSmallCircleBackgroundColorType {
    case smallCircleBackgroundColorGreen
    case smallCircleBackgroundColorYellow
    case smallCircleBackgroundColorRed
}

enum selectedCellColorType {
    case selectedCellViewColor
    case selectedCellViewHiddenColor
}

enum selectedCellLineColorType {
    case selectedCellLineColor
    case selectedCellLineHiddenColor
}

extension UIColor {
    static func customHomeColor(_ color: CustomHomeColorType) -> UIColor {
        switch color {
        case .homeBackgroundColor:
            return UIColor.init(red: 19/255, green: 18/255, blue: 20/255, alpha: 1)
        case .homeBoxColor:
            return UIColor.init(red: 24/255, green: 23/255, blue: 33/255, alpha: 1)
        }
    }
    
    static func customCircleColor(_ color: CustomCircleColorType) -> UIColor {
        switch color {
        case .circleColorGreen:
            return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 1)
        case .circleColorYellow:
            return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 1)
        case .circleColorRed:
            return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 1)
        }
    }
    
    static func customCircleAnimationColor(_ color: CustomCircleAnimationColorType) -> UIColor {
        switch color {
        case .circleAnimationColorGreen:
            return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 0.15)
        case .circleAnimationColorYellow:
            return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 0.15)
        case .circleAnimationColorRed:
            return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 0.15)
        }
    }
    
    static func customCircleBackgroundColor(_ color: CustomCircleBackgroundColorType) -> UIColor {
        switch color {
        case .circleBackgroundColorGreen:
            return UIColor.init(red: 40/255, green: 90/255, blue: 50/255, alpha: 1)
        case .circleBackgroundColorYellow:
            return UIColor.init(red: 90/255, green: 60/255, blue: 30/255, alpha: 1)
        case .circleBackgroundColorRed:
            return UIColor.init(red: 100/255, green: 40/255, blue: 40/255, alpha: 1)
        }
    }
    
    static func customSmallCircleColor(_ color: CustomSmallCircleColorType) -> UIColor {
        switch color {
        case .smallCircleColorGreen:
            return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 1)
        case .smallCircleColorYellow:
            return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 1)
        case .smallCircleColorRed:
            return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 1)
        }
    }
    
    static func customSmallCircleBackgroundColor(_ color: CustomSmallCircleBackgroundColorType) -> UIColor {
        switch color {
        case .smallCircleBackgroundColorGreen:
            return UIColor.init(red: 40/255, green: 90/255, blue: 50/255, alpha: 0.1)
        case .smallCircleBackgroundColorYellow:
            return UIColor.init(red: 90/255, green: 60/255, blue: 30/255, alpha: 0.1)
        case .smallCircleBackgroundColorRed:
            return UIColor.init(red: 100/255, green: 40/255, blue: 40/255, alpha: 0.1)
        }
    }
    
    static func selectedCellViewColor(_ color: selectedCellColorType) -> UIColor {
        switch color {
        case .selectedCellViewColor:
            return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 1.0)
        case .selectedCellViewHiddenColor:
            return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
        }
    }
    
    static func selectedCellLineViewColor(_ color: selectedCellLineColorType) -> CGColor {
        switch color {
        case .selectedCellLineColor:
            return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 1.0).cgColor
        case .selectedCellLineHiddenColor:
            return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0).cgColor
        }
    }
}
