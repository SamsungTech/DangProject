//
//  FirebaseAuthManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/29.
//

import Foundation

protocol FirebaseAuthManager {
    
    func signInFirebaseAuth(providerID: String,
                            idToken: String,
                            rawNonce: String?,
                            completionBlock: @escaping (_ success: Bool,_ : String) -> Void)
}
