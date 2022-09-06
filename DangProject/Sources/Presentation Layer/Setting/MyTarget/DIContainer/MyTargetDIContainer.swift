//
//  MyTargetDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation

class MyTargetDIContainer {
    func makeMyTargetViewController() -> MyTargetViewController {
        return MyTargetViewController(viewModel: makeMyTargetViewModel())
    }
    
    func makeMyTargetViewModel() -> MyTargetViewModel {
        return MyTargetViewModel(profileManageUseCase: makeProfileManageUseCase())
    }
    
    func makeProfileManageUseCase() -> ProfileManagerUseCase {
        return DefaultProfileManagerUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                            manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase(),
                                            manageFirebaseStorageUseCase: makeManageFirebaseStorageUseCase())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeManageFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
}
