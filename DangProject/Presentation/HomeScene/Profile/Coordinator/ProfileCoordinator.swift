//
//  ProfileCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
import UIKit

enum ProfileAccessibleViewType {
    case ProfileViewController
}

protocol ProfileCoordinatorProtocol: Coordinator {
    func dismissViewController()
}

class ProfileCoordinator: ProfileCoordinatorProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var diContainer = ProfileDIContainer()
    var parentViewController: UIViewController?
    
    init(navigationController: UINavigationController,
         parentViewController: UIViewController) {
        self.navigationController = navigationController
        self.parentViewController = parentViewController
    }
    
    init(parentViewController: UIViewController) {
        self.parentViewController = parentViewController
    }
    
    func start() {
        let viewController = diContainer.makeProfileViewController()
        viewController.coordinator = self
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
    
    func dismissViewController() {
        if let viewController = parentViewController {
            viewController.dismiss(animated: true)
        }
    }
}
