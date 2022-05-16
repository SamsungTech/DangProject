//
//  Extension.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/19.
//

import Foundation
import UIKit

protocol ReusableView: UIView {
    static var identifier: String { get }
}

extension ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
