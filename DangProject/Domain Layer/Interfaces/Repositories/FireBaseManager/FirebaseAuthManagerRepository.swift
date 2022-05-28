//
//  FirebaseAuthManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/04/29.
//

import Foundation

import RxSwift

protocol FirebaseAuthManagerRepository {
    
    var authResultObservable: PublishSubject<(Bool, String)> { get }
    
    func signInFirebaseAuth(providerID: String,
                            idToken: String,
                            rawNonce: String?)
}
