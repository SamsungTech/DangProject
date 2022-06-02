//
//  UIView+Ratio.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import UIKit

extension UIView {
    func xValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxX*(value/390)
    }
    
    func yValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxY*(value/844)
    }
    
    static var xMax: CGFloat {
        return UIScreen.main.bounds.maxX
    }
    
    func calculateXMax() -> CGFloat {
        return UIScreen.main.bounds.maxX
    }
}
