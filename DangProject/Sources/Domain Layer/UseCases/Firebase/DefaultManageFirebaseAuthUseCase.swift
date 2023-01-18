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
            guard let strongSelf = self else { return Disposables.create() }
            self?.firebaseAuthRepository.signInFirebaseAuth(providerID: providerID, idToken: idToken, rawNonce: rawNonce)
                .subscribe(onNext: {  isValid, message in
                    emitter.onNext((isValid, message))
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
}
