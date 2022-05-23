//
//  AccountCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation
import UIKit

class AccountCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var dIContainer = AccountDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = dIContainer.makeAccountViewController()
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
    
    func popAccountViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func pushProfileEditViewController() {
        let coordinator = ProfileCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

