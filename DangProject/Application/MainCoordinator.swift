//
//  AppCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/01/26.
//
import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - First Start
    var homeViewController: UINavigationController!
    var preferenceViewController: UINavigationController!
    var searchViewController: UINavigationController!
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeViewController = self.navigationController
        homeCoordinator.start()
        
        let preferenceCoordinator = PreferenceCoordinator(navigationController: UINavigationController())
        preferenceViewController = preferenceCoordinator.navigationController
        preferenceCoordinator.start()
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        searchViewController = searchCoordinator.navigationController
        searchCoordinator.start()
    }
    
}
