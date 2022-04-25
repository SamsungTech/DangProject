//
//  SettingCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

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
}


