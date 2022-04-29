//
//  FirebaseAuthManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/29.
//

import FirebaseAuth

final class DefaultFirebaseAuthManager: FirebaseAuthManager {
    
    func signInFirebaseAuth(providerID: String,
                            idToken: String,
                            rawNonce: String?,
                            completionBlock: @escaping (_ success: Bool,_ completionMessage : String) -> Void) {
        
        let credential = OAuthProvider.credential(withProviderID: providerID,
                                                  idToken: idToken,
                                                  rawNonce: rawNonce)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completionBlock(false, error.localizedDescription)
            }
            
            if let user = authResult?.user {
                completionBlock(true, user.uid)
            }
        }
    }
}
