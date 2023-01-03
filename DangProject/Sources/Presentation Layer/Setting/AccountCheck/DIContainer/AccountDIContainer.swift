//
//  AccountDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation

class AccountDIContainer {
    func makeAccountViewController() -> AccountViewController {
        return AccountViewController(viewModel: makeAccountViewModel())
    }
    
    func makeAccountViewModel() -> AccountViewModel {
        return AccountViewModel(managerFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase())
    }
    
    func makeFetchProfileUseCase() -> ProfileManagerUseCase {
        return DefaultProfileManagerUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeManageFirebaseStorageUseCase())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManageRepository())
    }
    
    func makeManageFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFireStorageManageRepository())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeFireStoreManageRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeFireStorageManageRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
}
