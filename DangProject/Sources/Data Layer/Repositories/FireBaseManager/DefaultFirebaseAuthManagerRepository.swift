//
//  FirebaseAuthManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/29.
//

import FirebaseAuth
import RxSwift

final class DefaultFirebaseAuthManagerRepository: FirebaseAuthManagerRepository {
    
    let authResultObservable = PublishSubject<(Bool, String)>()
    
    func signInFirebaseAuth(providerID: String,
                            idToken: String,
                            rawNonce: String?) {
        
        let credential = OAuthProvider.credential(withProviderID: providerID,
                                                  idToken: idToken,
                                                  rawNonce: rawNonce)
        
        Auth.auth().signIn(with: credential) { [unowned self] (authResult, error) in
            if let error = error {
                authResultObservable.onNext((false, error.localizedDescription))
            }
            
            if let user = authResult?.user {
                authResultObservable.onNext((true, user.uid))
            }
        }
    }
}
