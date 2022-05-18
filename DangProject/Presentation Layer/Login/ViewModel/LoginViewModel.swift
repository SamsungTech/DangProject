//
//  LoginViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/27.
//

import Foundation

import RxSwift
import RxRelay


protocol LoginViewModelInput {
    func signIn(providerID: String, idToken: String, rawNonce: String)
}

protocol LoginViewModelOutput {
    var profileExistenceObservable: PublishRelay<Bool> { get }
}

protocol LoginViewModelProtocol: LoginViewModelInput, LoginViewModelOutput { }

class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - init
    private let firebaseAuthUseCase: FirebaseAuthUseCase
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    private let disposeBag = DisposeBag()
    
    init(firebaseAuthUseCase: FirebaseAuthUseCase,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.firebaseAuthUseCase = firebaseAuthUseCase
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
        bindAuthorizeFirebaseUseCase()
        bindProfileExistence()
    }
    
    private func bindAuthorizeFirebaseUseCase() {
        firebaseAuthUseCase.authObservable
            .subscribe(onNext: { [weak self] isValid, id in
                if isValid {
                    self?.firebaseFireStoreUseCase.uploadFirebaseUID(uid: id)
                    self?.updateUserDefaultsUid(uid: id)
                }
                self?.checkProfileExistence(uid: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileExistence() {
        firebaseFireStoreUseCase.profileExistenceObservable
            .subscribe(onNext: { [weak self] isExist in
                if isExist {
                    self?.profileExistenceObservable.accept(true)
                } else {
                    self?.profileExistenceObservable.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Private Method
    private func checkProfileExistence(uid: String) {
        firebaseFireStoreUseCase.getProfileExistence(uid: uid)
    }
    
    private func updateUserDefaultsUid(uid: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(uid, forKey: UserInfoKey.firebaseUID)
    }
    
    //MARK: - Input
    func signIn(providerID: String, idToken: String, rawNonce: String) {
        firebaseAuthUseCase.requireFirebaseUID(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
    }
   
    //MARK: - Output
    let profileExistenceObservable = PublishRelay<Bool>()
    
    
    
}
