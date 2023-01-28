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
    let versionCheckManager: VersionCheckRepository
    private var versionData: VersionData = .empty

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.fireStoreManager = DefaultFireStoreManagerRepository()
        self.versionCheckManager = DefaultVersionCheckRepository()
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - First Start
    func start() {
        checkVersion()
    }
    
    private func checkVersion() {
        versionCheckManager.isUpdateAvailable { versionData, error in
            if error != nil {
                print("versionCheck Error")
            }
            self.versionData = versionData
            self.checkDemoVersion(versionState: versionData)
        }
    }
    
    // MARK: - Private
    private func checkDemoVersion(versionState: VersionData) {
        /// check demo app version
        fireStoreManager.getDemoDataInFireStore { demo in
            if demo {
                self.setDemoUIDInUserDefaults()
                self.checkAppIsFirstTime()
                self.checkUserUID(versionState: versionState)
            } else {
                self.deleteDemoUIDInUserDefaults()
                self.checkAppIsFirstTime()
                self.checkUserUID(versionState: versionState)
            }
        }
    }
    
    private func deleteDemoUIDInUserDefaults() {
        UserDefaults.standard.removeObject(forKey: UserInfoKey.demoUID)
    }
    
    private func setDemoUIDInUserDefaults() {
        UserDefaults.standard.set("KbjMogo76DRjnhmfr7sgLsM9O4Y2", forKey: UserInfoKey.demoUID)
    }
    
    private func checkAppIsFirstTime() {
        /// check app is first time
        if UserDefaults.standard.bool(forKey: UserInfoKey.tutorialFinished) == false {
            startOnboarding()
        }
    }
    
    private func checkUserUID(versionState: VersionData) {
        /// check userUID
        guard let userDefaultsUID = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else {
            return startLogin(versionState: versionState)
        }
        compareFireStoreUID(with: userDefaultsUID, versionState: versionState)
    }
    
    private func compareFireStoreUID(with userDefaultsUID: String,
                                     versionState: VersionData) {
        fireStoreManager.checkUIDInFireStore(uid: userDefaultsUID) { [weak self] bool in
            if bool {
                self?.startTabbar(versionState: versionState)
            } else {
                self?.startLogin(versionState: versionState)
            }
        }
    }

    private func startTabbar(versionState: VersionData) {
        let tabbarCoordinator = TabBarCoordinator(navigationController: navigationController,
                                                  versionData: versionData)
        childCoordinators.append(tabbarCoordinator)
        tabbarCoordinator.start()
    }

    private func startLogin(versionState: VersionData) {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController,
                                                coordinatorFinishDelegate: self,
                                                versionData: PresentationVersionModel.init(
                                                  version: versionData.version,
                                                  state: versionData.state))
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }

    private func startInputProfile(email: String) {
        let inputProfileCoordinator = InputProfileCoordinator(navigationController: navigationController,
                                                              coordinatorFinishDelegate: self,
                                                              email: email)
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
    case inputPersonalInformation(email: String)
    case tabBar
}


protocol CoordinatorFinishDelegate {
    func switchViewController(to viewController: viewControllerType)
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func switchViewController(to viewController: viewControllerType) {
        navigationController.viewControllers.removeAll()
        switch viewController {
        case .inputPersonalInformation(let email):
            startInputProfile(email: email)
        case .tabBar:
            startTabbar(versionState: self.versionData)
        }
    }
}
