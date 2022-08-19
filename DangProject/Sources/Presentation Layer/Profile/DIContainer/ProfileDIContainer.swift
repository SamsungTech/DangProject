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
        return ProfileViewModel(manageFirebaseStoreUseCase: makeFirebaseStoreUseCase(),
                                manageFirebaseStorageUseCase: makeFirebaseStorageUseCase(),
                                profileManagerUseCase: makeProfileManagerUseCase())
    }
    
    func makeProfileManagerUseCase() -> ProfileManagerUseCase {
        return DefaultProfileManagerUseCase(coreDataManagerRepository: makeCoreDataManagerRepository(),
                                            manageFirebaseFireStoreUseCase: makeFirebaseStoreUseCase(),
                                            manageFirebaseStorageUseCase: makeFirebaseStorageUseCase())
    }
    
    func makeFirebaseStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFirebaseManagerRepository())
    }
    
    func makeFirebaseStorageUseCase() -> ManageFirebaseStorageUseCase {
        return DefaultManageFireBaseStorageUseCase(firebaseStorageManagerRepository: makeFireBaseStorageManagerRepository())
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
