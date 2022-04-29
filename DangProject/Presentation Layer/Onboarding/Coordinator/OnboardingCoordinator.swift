import UIKit

class OnboardingCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diContainer = OnboardingDIContainer()
        let viewController = diContainer.makeOnboardingViewController()
        viewController.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func pushLoginView() {
        let child = LoginCoordinator(navigationController: navigationController)
        child.parentsCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

}
extension OnboardingCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let loginViewController = fromViewController as? LoginViewController {
            childDidFinish(loginViewController.coordinator)
        }
    }
}
