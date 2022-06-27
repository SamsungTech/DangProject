//
//  ProfileDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
import UIKit

class ProfileDIContainer {
    func makeProfileNavigationViewController() -> UINavigationController {
        let navigationViewController = UINavigationController(
            rootViewController: makeProfileViewController()
        )
        return navigationViewController
    }
    
    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController(viewModel: makeProfileViewModel())
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(useCase: makeProfileUseCase())
    }
    
    func makeProfileUseCase() -> ProfileUseCaseProtocol {
        return ProfileUseCase(repository: makeProfileRepository())
    }
    
    func makeProfileRepository() -> ProfileRepositoryProtocol {
        return ProfileRepository()
    }
    
    func makeProfileImagePickerController(_ viewController: ProfileViewController) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = viewController
        pickerController.allowsEditing = true
        return pickerController
    }
}
