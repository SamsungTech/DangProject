//
//  AuthorizeFirebaseUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class DefaultFirebaseAuthUseCase: FirebaseAuthUseCase {
    private let disposeBag = DisposeBag()
    
    //MARK: - Init
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
    
    //MARK: - Internal
    let authObservable = PublishSubject<(Bool, String)>()
    
    func requireFirebaseUID(providerID: String, idToken: String, rawNonce: String) {
        firebaseAuthRepository.signInFirebaseAuth(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
    }
    
}
