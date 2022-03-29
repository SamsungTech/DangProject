//
//  CustomColor.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension UIColor {
    // MARK: CustomHomeColor
    static var homeBackgroundColor: UIColor {
        return UIColor.init(red: 19/255, green: 18/255, blue: 20/255, alpha: 1)
    }
    static var homeBoxColor: UIColor {
        return UIColor.init(red: 24/255, green: 23/255, blue: 33/255, alpha: 1)
    }
    
    // MARK: CustomCircleColor
    static var circleColorGreen: UIColor {
        return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 1)
    }
    static var circleColorYellow: UIColor {
        return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 1)
    }
    static var circleColorRed: UIColor {
        return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 1)
    }
    
    // MARK: CustomCircleAnimationColor
    static var circleAnimationColorGreen: UIColor {
        return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 0.15)
    }
    static var circleAnimationColorYellow: UIColor {
        return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 0.15)
    }
    static var circleAnimationColorRed: UIColor {
        return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 0.15)
    }
    
    // MARK: CustomCircleBackgroundColor
    static var circleBackgroundColorGreen: UIColor {
        return UIColor.init(red: 40/255, green: 90/255, blue: 50/255, alpha: 1)
    }
    static var circleBackgroundColorYellow: UIColor {
        return UIColor.init(red: 90/255, green: 60/255, blue: 30/255, alpha: 1)
    }
    static var circleBackgroundColorRed: UIColor {
        return UIColor.init(red: 100/255, green: 40/255, blue: 40/255, alpha: 1)
    }
    
    // MARK: CustomSmallCircleColor
    static var smallCircleColorGreen: UIColor {
        return UIColor.init(red: 40/255, green: 194/255, blue: 50/255, alpha: 1)
    }
    static var smallCircleColorYellow: UIColor {
        return UIColor.init(red: 252/255, green: 175/255, blue: 36/255, alpha: 1)
    }
    static var smallCircleColorRed: UIColor {
        return UIColor.init(red: 252/255, green: 70/255, blue: 70/255, alpha: 1)
    }
     
    // MARK: CustomSmallCircleBackgroundColor
    static var smallCircleBackgroundColorGreen: UIColor {
        return UIColor.init(red: 40/255, green: 90/255, blue: 50/255, alpha: 0.1)
    }
    static var smallCircleBackgroundColorYellow: UIColor {
        return UIColor.init(red: 90/255, green: 60/255, blue: 30/255, alpha: 0.1)
    }
    static var smallCircleBackgroundColorRed: UIColor {
        return UIColor.init(red: 100/255, green: 40/255, blue: 40/255, alpha: 0.1)
    }
    
    // MARK: SelectedCellViewColor
    static var selectedCellViewColor: UIColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 1.0)
    }
    static var selectedCellViewHiddenColor: UIColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
    }
    
    // MARK: CurrentCellLineViewColor
    static var currentDayCellLineViewColor: CGColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 1.0).cgColor
    }
    static var currentDayCellLineViewHiddenColor: CGColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0).cgColor
    }
}
