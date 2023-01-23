//
//  HomeCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var diContainer = HomeDIContainer()
    var versionData: PresentationVersionModel
    
    init(navigationController: UINavigationController,
         versionData: PresentationVersionModel) {
        self.navigationController = navigationController
        self.versionData = versionData
    }
    
    func start() {
        let viewController = diContainer.makeHomeViewController()
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func pushProfileEditViewController() {
        let coordinator = ProfileCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func presentUpdateAlertView() {
        switch versionData.state {
        case .red:
            let alert = createRedAlert()
            self.navigationController.present(alert, animated: false)
        case .yellow:
            let alert = createYellowAlert()
            if UserDefaults.standard.bool(forKey: UserInfoKey.isYellowState) {
                self.navigationController.present(alert, animated: false)
            }
        case .green:
            break
        }
    }
    
    private func createYellowAlert() -> UIAlertController {
        let alert = UIAlertController(title: "업데이트 안내",
                                      message: "안정적인 서비스 사용을 위해 최신 버전 업데이트를 해주세요.",
                                      preferredStyle: UIAlertController.Style.alert)
        let cancelButton = UIAlertAction(title: "취소", style: .cancel) { _ in
            UserDefaults.standard.set(false, forKey: UserInfoKey.isYellowState)
            alert.dismiss(animated: false)
        }
        
        let storeButton = UIAlertAction(title: "업데이트", style: .default) { _ in
            UserDefaults.standard.set(self.versionData.version, forKey: UserInfoKey.previousYellowVersion)
            UserDefaults.standard.set(self.versionData.version, forKey: UserInfoKey.latestYellowVersion)
            self.openAppStore()
            alert.dismiss(animated: false)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(storeButton)
        return alert
    }
    
    private func createRedAlert() -> UIAlertController {
        let alert = UIAlertController(title: "업데이트 안내",
                                      message: "안정적인 서비스 사용을 위해 최신 버전 업데이트를 해주세요.",
                                      preferredStyle: UIAlertController.Style.alert)
        let storeButton = UIAlertAction(title: "업데이트", style: .default) { _ in
            self.openAppStore()
            alert.dismiss(animated: false)
        }
        
        alert.addAction(storeButton)
        return alert
    }
    
    func openAppStore() {
        let url = "itms-apps://itunes.apple.com/app/1625074042"
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
