//
//  HomeDIContainer.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import Foundation

class HomeDIContainer {
    func makeHomeViewController(coordinator: HomeCoordinator) -> HomeViewController {
        let viewController = HomeViewController()
        viewController.coordinator = coordinator
        return viewController
    }
}
