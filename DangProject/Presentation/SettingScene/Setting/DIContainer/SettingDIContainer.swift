//
//  SettingDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

class SettingDIContainer {
    func makeSettingNavigationViewController() -> UINavigationController {
        let navigationView = UINavigationController(
            rootViewController: makeSettingViewController()
        )
        return navigationView
    }
    
    func makeSettingViewController() -> SettingViewController {
        return SettingViewController(viewModel: makeSettingViewModel())
    }
    
    func makeSettingViewModel() -> SettingViewModelProtocol {
        return SettingViewModel(settingUseCase: makeSettingUseCase())
    }
    
    func makeSettingUseCase() -> SettingUseCase {
        return SettingUseCase(repository: makeSettingRepository())
    }
    
    func makeSettingRepository() -> SettingRepository {
        return SettingRepository()
    }
}
