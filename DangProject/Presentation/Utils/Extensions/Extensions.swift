//
//  Extensions.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/20.
//

import Foundation
import UIKit

extension UIView {
    func viewXRatio(_ value: CGFloat) -> CGFloat {
        let ratio = self.frame.maxX*(value/390)
        return ratio
    }
    func viewYRatio(_ value: CGFloat) -> CGFloat {
        let ratio = self.frame.maxY*(value/844)
        return ratio
    }
    func viewRadius(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

extension UIViewController {
    func viewXRatio(_ value: CGFloat) -> CGFloat {
        let ratio = self.view.bounds.maxX*(value/390)
        return ratio
    }
    func viewYRatio(_ value: CGFloat) -> CGFloat {
        let ratio = self.view.bounds.maxX*(value/844)
        return ratio
    }
}

