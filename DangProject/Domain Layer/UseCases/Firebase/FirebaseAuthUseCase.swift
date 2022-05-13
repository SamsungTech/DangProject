//
//  AuthorizeFirebaseUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class FirebaseAuthUseCase {
    
    let authObservable = PublishSubject<(Bool, String)>()
    private let disposeBag = DisposeBag()
    
    private let firebaseAuthRepository: FirebaseAuthManagerRepository
    
    init(firebaseAuthRepository: FirebaseAuthManagerRepository) {
        self.firebaseAuthRepository = firebaseAuthRepository
        bindFirebaseAuthRepository()
    }
    
    private func bindFirebaseAuthRepository() {
        firebaseAuthRepository.authResultObservable
            .subscribe(onNext: { [unowned self] isVaild, id in
                authObservable.onNext((isVaild, id))
            })
            .disposed(by: disposeBag)
    }
    
    func requireFirebaseUID(providerID: String, idToken: String, rawNonce: String) {
        firebaseAuthRepository.signInFirebaseAuth(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
    }
    
}
