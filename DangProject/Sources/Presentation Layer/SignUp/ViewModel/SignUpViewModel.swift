//
//  SignUpViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/12/06.
//

import Foundation

import RxSwift
import RxRelay

protocol SignUpViewModelInput {
    
}

protocol SignUpViewModelOutput {
    
}

protocol SignUpViewModelProtocol: SignUpViewModelInput, SignUpViewModelOutput { }

class SignUpViewModel: SignUpViewModelProtocol {
    
    private let manageFirebaseAuthUseCase: ManageFirebaseAuthUseCase
    private let manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    private let disposeBag = DisposeBag()
    
    init(manageFirebaseAuthUseCase: ManageFirebaseAuthUseCase,
         manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.manageFirebaseAuthUseCase = manageFirebaseAuthUseCase
        self.manageFirebaseFireStoreUseCase = manageFirebaseFireStoreUseCase
    }
    
}
