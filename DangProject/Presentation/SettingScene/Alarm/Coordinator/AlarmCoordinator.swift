//
//  AlramCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

class AlarmCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = AlarmDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeAlarmViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAlarmViewController() {
        self.navigationController.popViewController(animated: true)
    }
}
