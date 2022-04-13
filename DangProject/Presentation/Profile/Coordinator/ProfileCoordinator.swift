//
//  ProfileCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
import UIKit

class ProfileCoordinator: CoordinateEventProtocol {
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var diContainer = ProfileDIContainer()
    var parentViewController: HomeViewControllerProtocol?
    
    init(parentCoordinator: Coordinator?,
         navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.parentsCoordinator = parentCoordinator
    }
    
    init(parentCoordinator: Coordinator?,
         parentViewController: HomeViewControllerProtocol) {
        self.parentsCoordinator = parentCoordinator
        self.parentViewController = parentViewController
    }
    
    func start() {
        let viewController = diContainer.makeProfileViewController(coordinator: self)
        self.navigationController?.pushViewController(viewController, animated: false)
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

extension ProfileCoordinator {
    func navigationEvent(event: NavigationEventType, _ viewControllerType: ViewControllerType) {}
    func pushViewController(_ viewControllerType: ViewControllerType) {}
    func popViewController(_ viewControllerType: ViewControllerType) {}
    func presentViewController(_ viewControllerType: ViewControllerType) {}
    func dismissViewController(_ viewControllerType: ViewControllerType) {}
}
