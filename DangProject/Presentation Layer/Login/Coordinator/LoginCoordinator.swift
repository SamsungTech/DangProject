import UIKit

class LoginCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let coordinatorFinishDelegate: CoordinatorFinishDelegate
    
    init(navigationController: UINavigationController,
         coordinatorFinishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.coordinatorFinishDelegate = coordinatorFinishDelegate
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
}


extension LoginCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let inputPersonalInformationViewController = fromViewController as? InputPersonalInformationViewController {
            childDidFinish(inputPersonalInformationViewController.coordinator)
        }
    }
}
