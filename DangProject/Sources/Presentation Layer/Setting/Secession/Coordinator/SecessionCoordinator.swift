//
//  SecessionCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit

class SecessionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var diContainer = SecessionDIContainer()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeSecessionViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popSecessionViewController() {
        navigationController.popViewController(animated: true)
    }
}
