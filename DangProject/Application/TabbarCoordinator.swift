//
//  TabbarCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/04.
//
import UIKit

class TabbarCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    lazy var searchViewController = UINavigationController()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        childCoordinators.append(homeCoordinator)
        let homeViewController = homeCoordinator.navigationController
        homeCoordinator.start()
        
        let preferenceCoordinator = PreferenceCoordinator(navigationController: UINavigationController())
        childCoordinators.append(preferenceCoordinator)
        let preferenceViewController = preferenceCoordinator.navigationController
        preferenceCoordinator.start()
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        childCoordinators.append(searchCoordinator)
        searchViewController = searchCoordinator.navigationController
        searchCoordinator.start()
        
        let initialViewController = TabBarController(homeTab: homeViewController,
                                                     prefrenceTab: preferenceViewController,
                                                     searchViewController: searchViewController)
        initialViewController.coordinator = self

        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func presentSearchViewController(viewController: UIViewController) {
        viewController.present(searchViewController, animated: true)
    }
}
