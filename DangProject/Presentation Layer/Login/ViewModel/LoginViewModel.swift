//
//  LoginViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/27.
//

import Foundation

import RxSwift
import RxRelay

class LoginViewModel {
    
    let profileExistenceObservable = PublishRelay<Bool>()
    let disposeBag = DisposeBag()
    
    let firebaseAuthUseCase: FirebaseAuthUseCase
    let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    
    init(firebaseAuthUseCase: FirebaseAuthUseCase,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.firebaseAuthUseCase = firebaseAuthUseCase
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
        bindAuthorizeFirebaseUseCase()
        bindProfileExistence()
    }
    
    private func bindAuthorizeFirebaseUseCase() {
        firebaseAuthUseCase.authObservable
            .subscribe(onNext: { [unowned self] isValid, id in
                if isValid {
                    firebaseFireStoreUseCase.upLoadFirebaseUID(uid: id)
                    updateUserDefaultsUid(uid: id)
                }
                checkProfileExistence(uid: id)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindProfileExistence() {
        firebaseFireStoreUseCase.profileExistenceObservable
            .subscribe(onNext: { [unowned self] isExist in
                if isExist {
                    profileExistenceObservable.accept(true)
                } else {
                    profileExistenceObservable.accept(false)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func signIn(providerID: String, idToken: String, rawNonce: String) {
        firebaseAuthUseCase.requireFirebaseUID(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
    }
    
    private func checkProfileExistence(uid: String) {
        firebaseFireStoreUseCase.getProfileExistence(uid: uid)
    }
    
    private func updateUserDefaultsUid(uid: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(uid, forKey: UserInfoKey.firebaseUID)
    }

}
