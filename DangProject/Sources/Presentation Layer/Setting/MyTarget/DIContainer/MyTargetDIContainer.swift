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
        return MyTargetViewModel(fetchProfileUseCase: makeFetchProfileUseCase(),
                                 fireStoreUseCase: makeFireStoreUseCase())
    }
    
    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          manageFirebaseFireStoreUseCase: makeFireStoreUseCase(),
                                          manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFirebaseStoreManagerRepository())
    }
    
    func makeFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFirebaseStorageManagerRepository())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeFirebaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeFirebaseStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
