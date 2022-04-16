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
    
    // MARK: 재인 - 메인과 다른 코디네이터는 다른 거 같다.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - First Start
    lazy var homeViewController = UINavigationController()
    lazy var preferenceViewController = UINavigationController()
    lazy var searchViewController = UINavigationController()
    
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
    
    func presentSearchViewController(viewController: UIViewController) {
        viewController.present(searchViewController, animated: true)
    }
    
    //onboarding
    func checkFirstRun() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: UserInfoKey.onboarding) == false {
            let onboardingView = OnboardingMasterViewController()
            onboardingView.modalPresentationStyle = .fullScreen
            homeViewController.present(onboardingView, animated: false)
        }
    }
    
}
