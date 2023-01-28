import UIKit

class InputProfileCoordinator: NSObject, Coordinator {
    private let email: String
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorFinishDelegate: CoordinatorFinishDelegate
    
    
    init(navigationController: UINavigationController,
         coordinatorFinishDelegate: CoordinatorFinishDelegate,
         email: String) {
        self.navigationController = navigationController
        self.coordinatorFinishDelegate = coordinatorFinishDelegate
        self.email = email
    }
    
    func start() {
        let diContainer = InputProfileDIContainer()
        let viewController = diContainer.makeInputProfileViewController()
        viewController.coordinator = self
        viewController.coordinatorFinishDelegate = coordinatorFinishDelegate
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
    
    func retrieveInputEmail() -> String {
        return email
    }
}
