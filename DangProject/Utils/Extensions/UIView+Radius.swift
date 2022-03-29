//
//  ViewRadius.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/29.
//

import UIKit

extension UIView {
    func viewRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}
