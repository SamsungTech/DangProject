//
//  SettingCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

enum SettingRouterPath {
    case account
    case myTarget
    case alarm
    case appIntroduce
    case termsOfService
    case secession
}

class SettingCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let diContainer = SettingDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeSettingViewController()
        viewController.coordinator = self
        self.navigationController.delegate = self
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
    
    func decideViewController(_ viewController: SettingRouterPath) {
        switch viewController {
        case .account:
            self.pushAccountViewController()
        case .myTarget:
            self.pushMyTargetViewController()
        case .alarm:
            self.pushAlarmViewController()
        case .appIntroduce:
            self.pushAppIntroduceViewController()
        case .termsOfService:
            self.pushTermsOfServiceViewController()
        case .secession:
            self.pushSecessionViewController()
        }
    }
    
}

extension SettingCoordinator {
    private func pushAccountViewController() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func pushMyTargetViewController() {
        let coordinator = MyTargetCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func pushAlarmViewController() {
        let coordinator = AlarmCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func pushAppIntroduceViewController() {
        let coordinator = AppIntroduceCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func pushTermsOfServiceViewController() {
        let coordinator = TermCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func pushSecessionViewController() {
        let coordinator = SecessionCoordinator(navigationController: self.navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension SettingCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let accountViewController = fromViewController as? AccountViewController {
            childDidFinish(accountViewController.coordinator)
        }
        
    }
}

