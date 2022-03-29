//
//  Extensions.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import UIKit

extension UIView {
    func xValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxX*(value/390)
    }
    
    func yValueRatio(_ value: CGFloat) -> CGFloat {
        return UIScreen.main.bounds.maxY*(value/844)
    }
}


