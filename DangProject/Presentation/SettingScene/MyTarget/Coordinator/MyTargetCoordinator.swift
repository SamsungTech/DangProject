//
//  MyTargetCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import UIKit

class MyTargetCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    private let diContainer = MyTargetDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeMyTargetViewController()
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func popMyTargetViewController() {
        self.navigationController.popViewController(animated: true)
    }
}
