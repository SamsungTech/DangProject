//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

class HomeCoordinator: CoordinateEventProtocol {
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
    
    func navigationEvent(event: NavigationEventType,
                         _ viewControllerType: ViewControllerType) {
        switch event {
        case .push:
            pushViewController(viewControllerType)
        case .pop:
            popViewController(viewControllerType)
        case .present:
            presentViewController(viewControllerType)
        case .dismiss:
            dismissViewController(viewControllerType)
        }
    }
    func pushViewController(_ viewControllerType: ViewControllerType) {}
    func popViewController(_ viewControllerType: ViewControllerType) {}
    func presentViewController(_ viewControllerType: ViewControllerType) {
        switch viewControllerType {
        case .profile(let viewController):
            presentProfile(viewController)
        }
    }
    func dismissViewController(_ viewControllerType: ViewControllerType) {}
}

extension HomeCoordinator {
    private func presentProfile(_ viewController: UIViewController) {
        let coordinator = ProfileCoordinator(
            parentCoordinator: self,
            parentViewController: viewController as! HomeViewControllerProtocol
        )
        let presentView = coordinator.diContainer.makeProfileNavigationViewController(coordinator: coordinator)
        presentView.modalPresentationStyle = .fullScreen
        viewController.present(presentView, animated: true)
    }
}
