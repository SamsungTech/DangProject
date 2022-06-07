//
//  AppIntroduceCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit

class AppIntroduceCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var diContainer = AppIntroduceDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeAppIntroduceViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func popAppIntroduceViewController() {
        navigationController.popViewController(animated: true)
    }
}
