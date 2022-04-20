//
//  MainCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import UIKit

enum NavigationEventType {
    case push
    case pop
    case present
    case dismiss(UIViewController)
}

protocol Coordinator: AnyObject {
    var parentsCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start() // MARK: 무조건 PushView할때만
    func childDidFinish(_ child: Coordinator?)
}

class MainCoordinator: Coordinator {
    var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.parentsCoordinator = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
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
