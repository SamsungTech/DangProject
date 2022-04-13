//
//  ProfileDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
import UIKit

class ProfileDIContainer {
    func makeProfileNavigationViewController(coordinator: Coordinator) -> UIViewController {
        let navigationViewController = UINavigationController(
            rootViewController: makeProfileViewController(coordinator: coordinator)
        )
        return navigationViewController
    }
    
    func makeProfileViewController(coordinator: Coordinator) -> UIViewController {
        return ProfileViewController.create(viewModel: makeProfileViewModel(),
                                            coordinator: coordinator)
    }
    
    func makeProfileViewModel() -> ProfileViewModelProtocol {
        return ProfileViewModel(useCase: makeProfileUseCase())
    }
    
    func makeProfileUseCase() -> ProfileUseCaseProtocol {
        return ProfileUseCase(repository: makeProfileRepository())
    }
    
    func makeProfileRepository() -> ProfileRepositoryProtocol {
        return ProfileRepository()
    }
}
