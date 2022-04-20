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
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController?
    var diContainer = ProfileDIContainer()
    var parentViewController: HomeViewControllerProtocol?
    var viewController: ProfileViewControllerProtocol?
    
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
        self.viewController = viewController as? ProfileViewControllerProtocol
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func click(event: NavigationEventType) {
        switch event {
        case .push:
            break
        case .pop:
            break
        case .present:
            break
        case .dismiss:
            dismissViewController()
        }
    }
    
    func dismissViewController() {
        
        if let viewController = viewController as? UIViewController {
            viewController.dismiss(animated: true)
        }
    }
}
