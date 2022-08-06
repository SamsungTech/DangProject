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
    private var profileData: ProfileDomainModel?
    
    init(navigationController: UINavigationController,
         profileData: ProfileDomainModel) {
        self.navigationController = navigationController
        self.profileData = profileData
    }
    
    func start() {
        guard let profileData = profileData else { return }
        let viewController = diContainer.makeProfileViewController(profileData)
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
    
    func dismissViewController(_ viewController: UIViewController) {
        viewController.dismiss(animated: true)
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
