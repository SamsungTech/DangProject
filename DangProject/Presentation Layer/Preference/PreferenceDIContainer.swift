//
//  PreferenceDIContainer.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import Foundation

class PreferenceDIContainer {
    func makePreferenceViewController(coordinator: PreferenceCoordinator) -> PreferenceViewController {
        let viewController = PreferenceViewController()
        viewController.coordinator = coordinator
        return viewController
    }
}
