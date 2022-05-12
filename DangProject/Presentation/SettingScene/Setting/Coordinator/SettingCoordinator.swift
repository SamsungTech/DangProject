//
//  SettingCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

enum SettingRouterPath {
    case account
    case myTarget
    case theme
    case alarm
    case appIntroduce
    case version
    case termsOfService
}

class SettingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var diContainer = SettingDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeSettingViewController()
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func pushAlarmViewController() {
        let coordinator = AlarmCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}


