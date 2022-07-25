//
//  ProfileDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/12.
//

import Foundation
import UIKit

class ProfileDIContainer {
    func makeProfileViewController() -> ProfileViewController {
        return ProfileViewController(viewModel: makeProfileViewModel())
    }
    
    func makeProfileViewModel() -> ProfileViewModel {
        return ProfileViewModel(firebaseStoreUseCase: makeFirebaseStoreUseCase(),
                                firebaseStorageUseCase: makeFirebaseStorageUseCase(),
                                fetchProfileUseCase: makeFetchProfileUseCase())
    }
    
    func makeFetchProfileUseCase() -> FetchProfileUseCase {
        return DefaultFetchProfileUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                          firebaseFireStoreUseCase: makeFirebaseStoreUseCase())
    }
    
    func makeFirebaseStoreUseCase() -> FirebaseFireStoreUseCase {
        return DefaultFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFirebaseManagerRepository())
    }
    
    func makeFirebaseStorageUseCase() -> FirebaseStorageUseCase {
        return DefaultFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFireBaseStorageManagerRepository())
    }
    
    func makeFireBaseStorageManagerRepository() -> FireBaseStorageManagerRepository {
        return DefaultFirebaseStorageManagerRepository()
    }
    
    func makeFirebaseManagerRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
    
    func makeCoreDataManagerRepository() -> CoreDataManagerRepository {
        return DefaultCoreDataManagerRepository()
    }
    
    func makeProfileImagePickerController(_ viewController: ProfileViewController) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = viewController
        pickerController.allowsEditing = true
        return pickerController
    }
}
