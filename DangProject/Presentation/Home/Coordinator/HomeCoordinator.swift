//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = HomeDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeCreateHomeViewController(coordinator: self)
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
