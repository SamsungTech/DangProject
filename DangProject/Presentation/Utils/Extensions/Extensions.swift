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
    func setGradient(color1: UIColor, color2: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.do {
            $0.colors = [color1.cgColor, color2.cgColor]
            $0.locations = [0.0, 1.0]
            $0.startPoint = CGPoint(x: 0.0, y: 0.0)
            $0.endPoint = CGPoint(x: 0.0, y: 1.0)
            $0.frame = self.bounds
        }
        self.layer.insertSublayer(gradient, at: 0)
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

