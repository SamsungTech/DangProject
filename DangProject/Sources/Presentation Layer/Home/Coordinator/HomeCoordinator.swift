//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = HomeDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeHomeViewController()
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentProfile(_ viewController: UIViewController,
                        _ profileData: ProfileDomainModel) {
        let navigationController = UINavigationController()
        let coordinator = ProfileCoordinator(navigationController: navigationController,
                                             profileData: profileData)
        coordinator.start()
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        viewController.present(navigationController, animated: true)
    }
}
