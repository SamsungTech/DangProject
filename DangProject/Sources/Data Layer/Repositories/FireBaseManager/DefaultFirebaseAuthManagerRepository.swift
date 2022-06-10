//
//  FirebaseAuthManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/29.
//

import FirebaseAuth
import RxSwift

final class DefaultFirebaseAuthManagerRepository: FirebaseAuthManagerRepository {
        
    func signInFirebaseAuth(providerID: String,
                            idToken: String,
                            rawNonce: String?) -> Observable<(Bool, String)> {
        return Observable.create() { emitter in
            let credential = OAuthProvider.credential(withProviderID: providerID,
                                                      idToken: idToken,
                                                      rawNonce: rawNonce)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    emitter.onNext((false, error.localizedDescription))
                }
                
                if let user = authResult?.user {
                    emitter.onNext((true, user.uid))
                }
            }
            return Disposables.create()
        }
    }

}
