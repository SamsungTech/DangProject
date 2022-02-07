//
//  SearchFoodCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let diContainer = SearchDIContainer()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let viewController = diContainer.makeSearchViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
}
