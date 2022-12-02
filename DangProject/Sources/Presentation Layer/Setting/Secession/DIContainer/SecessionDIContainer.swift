//
//  SecessionDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/19.
//

import Foundation

class SecessionDIContainer {
    func makeSecessionViewController() -> SecessionViewController {
        return SecessionViewController(viewModel: makeSecessionViewModel())
    }
    
    func makeSecessionViewModel() -> SecessionViewModel {
        return SecessionViewModel(resignUseCase: makeResignUseCase())
    }
    
    func makeResignUseCase() -> ResignUseCase {
        return DefaultResignUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                    fireStoreManagerRepository: makeFireStoreManagerRepository())
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeFireStoreManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
