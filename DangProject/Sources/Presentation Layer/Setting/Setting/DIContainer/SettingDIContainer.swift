//
//  SettingDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import UIKit

class SettingDIContainer {
    
    func makeSettingViewController() -> SettingViewController {
        return SettingViewController(viewModel: makeSettingViewModel())
    }
    
    func makeSettingViewModel() -> SettingViewModelProtocol {
        return SettingViewModel(fetchProfileUseCase: makeFetchProfileUseCase())
    }

    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeManageFirebaseStorageUseCase())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeManageFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
}
