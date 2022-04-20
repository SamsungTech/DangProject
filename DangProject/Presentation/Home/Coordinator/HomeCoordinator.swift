//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

enum HomeAccessibleViewType {
    case profile(UIViewController)
}

protocol HomeCoordinatorProtocol: Coordinator {
    func navigationEvent(event: NavigationEventType,
                         type: HomeAccessibleViewType)
    func pushViewController(type: HomeAccessibleViewType)
    func popViewController(type: HomeAccessibleViewType)
    func presentViewController(type: HomeAccessibleViewType)
    func dismissViewController(type: HomeAccessibleViewType)
}

class HomeCoordinator: HomeCoordinatorProtocol {
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = HomeDIContainer()
    var parentViewController: HomeViewControllerProtocol?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeHomeViewController(coordinator: self)
        self.navigationController.pushViewController(viewController, animated: false)
        self.parentViewController = viewController as? HomeViewControllerProtocol
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationEvent(event: NavigationEventType, type: HomeAccessibleViewType) {
        switch event {
        case .push:
            pushViewController(type: type)
        case .pop:
            popViewController(type: type)
        case .present:
            presentViewController(type: type)
        case .dismiss:
            dismissViewController(type: type)
        }
    }
    func pushViewController(type: HomeAccessibleViewType) {}
    func popViewController(type: HomeAccessibleViewType) {}
    func presentViewController(type: HomeAccessibleViewType) {
        switch type {
        case .profile(let viewController):
            presentProfile(viewController)
        }
    }
    func dismissViewController(type: HomeAccessibleViewType) {}
}

extension HomeCoordinator {
    private func presentProfile(_ viewController: UIViewController) {
        let coordinator = ProfileCoordinator(parentCoordinator: self,
                                             parentViewController: viewController as! HomeViewControllerProtocol)
        let presentView = coordinator.diContainer.makeProfileNavigationViewController(coordinator: coordinator)
        presentView.modalPresentationStyle = .fullScreen
        viewController.present(presentView, animated: true)
    }
}
