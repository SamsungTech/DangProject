//
//  UIViewController+Ratio.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

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
