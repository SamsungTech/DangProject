import UIKit

class InputPersonalInformationCoordinator: NSObject, Coordinator {
    
    weak var parentsCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var coordinatorFinishDelegate: CoordinatorFinishDelegate
    
    init(navigationController: UINavigationController,
         coordinatorFinishDelegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.coordinatorFinishDelegate = coordinatorFinishDelegate
    }
    
    func start() {
        let diContainer = InputPersonalInformationDIContainer()
        let viewController = diContainer.makeInputPersonalInformationViewController()
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
}
