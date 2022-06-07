//
//  CoordinatorFinishDelegate.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/04.
//

import Foundation
enum viewControllerType {
    case inputPersonalInformation
    case tabBar
}
protocol CoordinatorFinishDelegate {
    func switchViewController(to viewController: viewControllerType)
}
