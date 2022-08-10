//
//  ProfileCoordinator.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import UIKit

enum ProfileAccessibleViewType {
    case ProfileViewController
}

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var diContainer = ProfileDIContainer()
    private var pickerController: UIImagePickerController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = diContainer.makeProfileViewController()
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
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func presentPickerController(_ viewController: UIViewController) {
        guard let viewController = viewController as? ProfileViewController else { return }
        pickerController = diContainer.makeProfileImagePickerController(viewController)
        guard let pickerController = self.pickerController else { return }        
        viewController.present(pickerController, animated: true)
    }
    
    func dismissPickerController() {
        pickerController?.dismiss(animated: true)
    }
}
