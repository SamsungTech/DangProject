//
//  SignUpDIContainer.swift
//  DangProject
//
//  Created by 김동우 on 2022/12/06.
//

import UIKit

class SignUpDIContainer {
    
    func makeSignUpViewController() -> SignUpViewController {
        return SignUpViewController(viewModel: makeSignUpViewModel())
    }
    
    func makeSignUpViewModel() -> SignUpViewModel {
        return SignUpViewModel(manageFirebaseAuthUseCase: makeManageFirebaseAuthUseCase(),
                               manageFirebaseFireStoreUseCase: makeManageFirebaseFireStoreUseCase())
    }
    
    func makeManageFirebaseAuthUseCase() -> ManageFirebaseAuthUseCase {
        return DefaultManageFirebaseAuthUseCase(firebaseAuthRepository: makeFirebaseAuthRepository())
    }
    
    func makeManageFirebaseFireStoreUseCase() -> ManageFirebaseFireStoreUseCase {
        return DefaultManageFirebaseFireStoreUseCase(fireStoreManagerRepository: makeFireStoreManageRepository())
    }
    
    func makeFirebaseAuthRepository() -> FirebaseAuthManagerRepository {
        return DefaultFirebaseAuthManagerRepository()
    }
    
    func makeFireStoreManageRepository() -> FireStoreManagerRepository {
        return DefaultFireStoreManagerRepository()
    }
}
