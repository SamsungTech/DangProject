//
//  SignUpCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/12/06.
//

import UIKit

class SignUpCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diContainer = SignUpDIContainer()
        let viewController = diContainer.makeSignUpViewController()
        viewController.coordinator = self
        navigationController.delegate = self
        navigationController.viewControllers = [viewController]
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


extension SignUpCoordinator: UINavigationControllerDelegate {
    
}
