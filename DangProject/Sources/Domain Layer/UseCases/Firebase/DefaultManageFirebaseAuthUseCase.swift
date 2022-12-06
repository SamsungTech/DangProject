//
//  AuthorizeFirebaseUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class DefaultManageFirebaseAuthUseCase: ManageFirebaseAuthUseCase {
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Init
    private let firebaseAuthRepository: FirebaseAuthManagerRepository
    
    init(firebaseAuthRepository: FirebaseAuthManagerRepository) {
        self.firebaseAuthRepository = firebaseAuthRepository
    }
    
    //MARK: - Internal
    let authObservable = PublishSubject<(Bool, String)>()
    
    func requireFirebaseUID(providerID: String, idToken: String, rawNonce: String) -> Observable<(Bool, String)> {
        return Observable.create { [weak self] emitter in
            self?.firebaseAuthRepository.signInFirebaseAuth(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
                .subscribe(onNext: {  isValid, message in
                    emitter.onNext((isValid, message))
                })
                .disposed(by: self!.disposeBag)
            return Disposables.create()
        }
    }
    
    func requireFirebaseEmail(email: String, password: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.firebaseAuthRepository.signInFirebaseEmailAuth(email: email, password: password)
                .subscribe(onNext: { bool in
                    emitter.onNext(bool)
                })
                .disposed(by: self!.disposeBag)
            return Disposables.create()
        }
    }
}
