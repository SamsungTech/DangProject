import UIKit

class LoginCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let coordinatorFinishDelegate: CoordinatorFinishDelegate
    var versionData: PresentationVersionModel
    
    init(navigationController: UINavigationController,
         coordinatorFinishDelegate: CoordinatorFinishDelegate,
         versionData: PresentationVersionModel) {
        self.navigationController = navigationController
        self.coordinatorFinishDelegate = coordinatorFinishDelegate
        self.versionData = versionData
    }
    
    func start() {
        let diContainer = LoginDIContainer()
        let viewController = diContainer.makeLoginViewController()
        viewController.coordinator = self
        viewController.coordinatorFinishDelegate = coordinatorFinishDelegate
        navigationController.delegate = self
        navigationController.viewControllers = [viewController]
    }

    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func presentUpdateAlertViewFromLoginView() {
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


extension LoginCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let inputPersonalInformationViewController = fromViewController as? InputProfileViewController {
            childDidFinish(inputPersonalInformationViewController.coordinator)
        }
    }
}
