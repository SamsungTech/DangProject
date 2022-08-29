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
        return SettingViewModel(fetchProfileUseCase: makeFetchProfileUseCase())
    }
    
    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(coreDataManagerRepository: makeCoreDataManageRepository(),
                                          manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeManageFirebaseStorageUseCase())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManageRepository())
    }
    
    func makeManageFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeCoreDataManageRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeFireStoreManageRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
}
