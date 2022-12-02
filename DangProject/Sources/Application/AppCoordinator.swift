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

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let fireStoreManager: FireStoreManagerRepository

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.fireStoreManager = DefaultFireStoreManagerRepository()
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - First Start
    func start() {
            /// check app is first time
            if UserDefaults.standard.bool(forKey: UserInfoKey.tutorialFinished) == false {
                startOnboarding()
            }
            /// check userUID
            guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else {
                return startLogin()
            }
            compareFireStoreUID(with: userDefaultsUID)
    }
    
    // MARK: - Private
    
    private func compareFireStoreUID(with userDefaultsUID: String) {
        fireStoreManager.readUIDInFirestore(uid: userDefaultsUID) { [weak self] uid in
            if uid == userDefaultsUID {
                self?.startTabbar()
                self?.startInputProfile()
            }
            else {
                self?.startLogin()
            }
        }
    }

    private func startTabbar() {
        let tabbarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }

    private func startLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, coordinatorFinishDelegate: self)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    private func startInputProfile() {
        let inputProfileCoordinator = InputProfileCoordinator(navigationController: navigationController, coordinatorFinishDelegate: self)
        childCoordinators.append(inputProfileCoordinator)
        inputProfileCoordinator.start()

    }

    private func startOnboarding() {
        let onboardingNavigationViewController = UINavigationController()
        onboardingNavigationViewController.modalPresentationStyle = .fullScreen
        let onboardingCoordinator = OnboardingCoordinator(navigationController: onboardingNavigationViewController)
        onboardingCoordinator.start()
        navigationController.present(onboardingNavigationViewController, animated: false)
    }
}

enum viewControllerType {
    case inputPersonalInformation
    case tabBar
}

protocol CoordinatorFinishDelegate {
    func switchViewController(to viewController: viewControllerType)
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func switchViewController(to viewController: viewControllerType) {
        navigationController.viewControllers.removeAll()
        switch viewController {
        case .inputPersonalInformation:
            startInputProfile()
        case .tabBar:
            startTabbar()
        }
    }
}
