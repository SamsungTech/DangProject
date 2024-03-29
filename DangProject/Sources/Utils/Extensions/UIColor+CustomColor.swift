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
        return UIColor.init(red: 238/255, green: 240/255, blue: 243/255, alpha: 1)
    }
    static var homeBoxColor: UIColor {
        return UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    static var homeBackgroundColorAlphaZero: UIColor {
        return UIColor.init(red: 19/255, green: 18/255, blue: 20/255, alpha: 0)
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
    static var circleColorGray: UIColor {
        return UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
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
    static var circleAnimationColorGray: UIColor {
        return UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 0.15)
    }
    
    // MARK: CustomCircleBackgroundColor
    static var circleBackgroundColorGreen: UIColor {
        return UIColor.init(red: 175/255, green: 215/255, blue: 165/255, alpha: 1)
    }
    static var circleBackgroundColorYellow: UIColor {
        return UIColor.init(red: 215/255, green: 200/255, blue: 175/255, alpha: 1)
    }
    static var circleBackgroundColorRed: UIColor {
        return UIColor.init(red: 215/255, green: 180/255,  blue: 180/255, alpha: 1)
    }
    static var circleBackgroundColorGray: UIColor {
        return UIColor.init(red: 190/255, green: 190/255, blue: 190/255, alpha: 1)
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
    static var smallCircleColorGray: UIColor {
        return UIColor.init(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
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
    static var smallCircleBackgroundColorGray: UIColor {
        return UIColor.init(red: 174/255, green: 174/255, blue: 178/255, alpha: 0.1)
    }
    
    // MARK: SelectedCellViewColor
    static var selectedCellViewColor: UIColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 1.0)
    }
    static var selectedCellViewHiddenColor: UIColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
    }
    
    // MARK: CurrentCellLineViewColor
    static var currentDayCellLineViewColor: UIColor {
        return UIColor.init(red: 80/255, green: 80/255, blue: 100/255, alpha: 0.2)
    }
    static var currentDayCellLineViewHiddenColor: UIColor {
        return UIColor.init(red: 47/255, green: 45/255, blue: 62/255, alpha: 0.0)
    }
    
    // MARK: ProfileTextField
    static var profileImageBackgroundColor: UIColor {
        return UIColor.init(red: 35/255, green: 36/255, blue: 41/255, alpha: 0.1)
    }
    
    static var profileTextFieldBackgroundColor: UIColor {
        return UIColor.init(red: 26/255, green: 24/255, blue: 29/255, alpha: 1.0)
    }
    
    static var profileLineColor: UIColor {
        return UIColor.init(red: 33/255, green: 31/255, blue: 38/255, alpha: 1.0)
    }
    
    // MARK: ButtonColor
    static var buttonColor: UIColor {
        return UIColor.init(red: 158/255, green: 168/255, blue: 180/255, alpha: 1.0)
    }
    
    // MARK: FontColor
    static var customFontColorBlack: UIColor {
        return UIColor.black
    }
    static var customFontColorGray: UIColor {
        return UIColor.init(red: 114/255, green: 118/255, blue: 122/255, alpha: 1)
    }
    static var customLabelColorBlack: UIColor {
        return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    static var customLabelColorBlack2: UIColor {
        return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    static var customLabelColorBlack3: UIColor {
        return UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.9)
    }
}
