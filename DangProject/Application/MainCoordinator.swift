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
    
    func start() {
        
    }
    
    func startHomeCoordinator() -> HomeViewController {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        
        childCoordinators.append(homeCoordinator)
        
        return homeCoordinator.firstStart()
    }
    
    func startPreferenceCoordinator() -> PreferenceViewController {
        let preferenceCoordinator = PreferenceCoordinator(navigationController: navigationController)
        
        childCoordinators.append(preferenceCoordinator)
        
        return preferenceCoordinator.firstStart()
    }
    
}
