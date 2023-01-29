//
//  CGRect.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/29.
//

import UIKit

extension CGRect {
    static func profileViewDefaultCGRect(_ height: CGFloat) -> CGRect {
        let maxX = UIScreen.main.bounds.maxX
        let maxY = UIScreen.main.bounds.maxY
        let height = UIScreen.main.bounds.maxY*(height/844)
        return CGRect(x: .zero,
                      y: .zero,
                      width: maxX,
                      height: height)
    }
}
