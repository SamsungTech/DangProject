//
//  FirebaseAuthUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

import RxSwift

protocol FirebaseAuthUseCase {
    var authObservable: PublishSubject<(Bool, String)> { get }
    func requireFirebaseUID(providerID: String, idToken: String, rawNonce: String)
}