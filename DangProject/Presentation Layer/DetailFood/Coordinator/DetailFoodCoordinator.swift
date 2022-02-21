//
//  DetailFoodCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation
import UIKit

class DetailFoodCoordinator: Coordinator {
    
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var selectedFood: FoodViewModel
    var parentableViewController: DetailFoodParentable
    init(navigationController: UINavigationController,
         selectedFood: FoodViewModel,
         parentableViewController: DetailFoodParentable) {
        self.navigationController = navigationController
        self.selectedFood = selectedFood
        self.parentableViewController = parentableViewController
    }
    
    func start() {
        let diContainer = DetailFoodDIContainer(selectedFood: selectedFood)
        let viewController = diContainer.makeDetailFoodViewController()
        viewController.coordinator = self
        viewController.parentableViewController = parentableViewController
        navigationController.pushViewController(viewController, animated: true)
    }
}
