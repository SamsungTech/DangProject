import UIKit

class LoginCoordinator: NSObject, Coordinator {
    
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let diContainer = LoginDIContainer()
        let viewController = diContainer.makeLoginViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
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
