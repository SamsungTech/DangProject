//
//  SearchFoodCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/03.
//

import Foundation
import UIKit

class SearchCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diContainer = SearchDIContainer()
        let viewController = diContainer.makeSearchViewController()
        viewController.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func pushDetailFoodView(food: FoodViewModel,
                            from viewController: DetailFoodParentable) {
        let child = DetailFoodCoordinator(navigationController: navigationController,
                                          selectedFood: food,
                                          parentableViewController: viewController)
        child.parentsCoordinator = self
        childCoordinators.append(child)
        child.start()
    }

}
extension SearchCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let detailFoodViewController = fromViewController as? DetailFoodViewController {
            childDidFinish(detailFoodViewController.coordinator)
        }
    }
}
