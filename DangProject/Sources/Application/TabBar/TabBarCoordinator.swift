//
//  TabbarCoordinator.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/04.
//
import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var versionData: VersionData
    lazy var searchViewController = UINavigationController()
    
    init(navigationController: UINavigationController,
         versionData: VersionData) {
        self.navigationController = navigationController
        self.versionData = versionData
    }
    
    func start() {
        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController(),
                                              versionData: PresentationVersionModel.init(
                                                version: versionData.version,
                                                state: versionData.state))
        childCoordinators.append(homeCoordinator)
        let homeViewController = homeCoordinator.navigationController
        homeCoordinator.start()
        
        let settingCoordinator = SettingCoordinator(navigationController: UINavigationController())
        childCoordinators.append(settingCoordinator)
        let settingViewController = settingCoordinator.navigationController
        settingCoordinator.start()
        
        let initialViewController = TabBarController(homeTab: homeViewController,
                                                     settingTab: settingViewController,
                                                     searchViewController: searchViewController)
        initialViewController.coordinator = self

        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func presentSearchViewController(viewController: UIViewController) {
        let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
        searchViewController = searchCoordinator.navigationController
        searchViewController.modalPresentationStyle = .fullScreen
        searchCoordinator.start()
        
        viewController.present(searchViewController, animated: true)
    }
}
