//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = HomeDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeHomeViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }    
}
