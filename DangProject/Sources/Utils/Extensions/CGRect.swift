//
//  CGRect.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/29.
//

import UIKit

extension CGRect {
    static func profileViewDefaultCGRect(_ height: CGFloat) -> CGRect {
        let xMax = UIScreen.main.bounds.maxX
        let yMax = UIScreen.main.bounds.maxY
        let height = yMax*(height/844)
        return CGRect(x: .zero,
                      y: .zero,
                      width: xMax,
                      height: height)
    }
}
