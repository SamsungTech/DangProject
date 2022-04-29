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
    var homeViewController = UINavigationController()
    var preferenceViewController = UINavigationController()
    var searchViewController = UINavigationController()
    lazy var onboardingNavigationViewContoller = UINavigationController()
    
    func start() {

        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        childCoordinators.append(homeCoordinator)
        homeViewController = self.navigationController
        homeCoordinator.start()
        
        let preferenceCoordinator = PreferenceCoordinator(navigationController: UINavigationController())
        childCoordinators.append(preferenceCoordinator)
        preferenceViewController = preferenceCoordinator.navigationController
        preferenceCoordinator.start()
        
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        childCoordinators.append(searchCoordinator)
        searchViewController = searchCoordinator.navigationController
        searchCoordinator.start()
    }
    
    func presentSearchViewController(viewController: UIViewController) {
        viewController.present(searchViewController, animated: true)
    }
    
    //onboarding
    func checkFirstRun() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: UserInfoKey.onboarding)
        if userDefaults.bool(forKey: UserInfoKey.onboarding) == false {
            startOnboarding()
        }
    }
    
    func startOnboarding() {
        onboardingNavigationViewContoller.modalPresentationStyle = .fullScreen
        let onboardingCoordinator = OnboardingCoordinator(navigationController: onboardingNavigationViewContoller)
        onboardingCoordinator.start()
        homeViewController.present(onboardingNavigationViewContoller, animated: false)
    }
    
}
