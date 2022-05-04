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
    // MARK: 재인 - 메인과 다른 코디네이터는 다른 거 같다.
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.fireStoreManager = DefaultFireStoreManagerRepository()
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - First Start
    func start() {
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }

        fireStoreManager.checkProfileField(with: "onboarding", uid: userDefaultsUID){ onboardingIsDone in
            if !onboardingIsDone {
                self.startOnboarding()
            }
            self.checkUID(userDefaultUID: userDefaultsUID)
        }        
    }
    
    func checkUID(userDefaultUID: String) {
        fireStoreManager.readUIDInFirestore(uid: userDefaultUID) { uid in
            if uid == userDefaultUID {
                self.startTabbar()
            }
            else {
                self.startLogin()
            }
        }
    }
    
    func startTabbar() {
        let tabbarCoordinator = TabBarCoordinator(navigationController: navigationController)
        childCoordinators.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }
    
    func startLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, coordinatorFinishDelegate: self)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    func startInputPersonalInformation() {
        let inputPersonalInformationCoordinator = InputPersonalInformationCoordinator(navigationController: navigationController, coordinatorFinishDelegate: self)
        childCoordinators.append(inputPersonalInformationCoordinator)
        inputPersonalInformationCoordinator.start()
        
    }
    
    func startOnboarding() {
        let onboardingNavigationViewController = UINavigationController()
        onboardingNavigationViewController.modalPresentationStyle = .fullScreen
        let onboardingCoordinator = OnboardingCoordinator(navigationController: onboardingNavigationViewController)
        onboardingCoordinator.start()
        navigationController.present(onboardingNavigationViewController, animated: false)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func switchViewController(to viewController: viewControllerType) {
        self.navigationController.viewControllers.removeAll()
        switch viewController {
        case .inputPersonalInformation:
            startInputPersonalInformation()
        case .tabBar:
            startTabbar()
        }
    }
}
