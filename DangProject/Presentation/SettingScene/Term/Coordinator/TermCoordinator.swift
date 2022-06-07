//
//  TermCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import UIKit

class TermCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private var diContainer = TermDIContainer()
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeTermViewController()
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popTermViewController() {
        navigationController?.popViewController(animated: true)
    }
}
