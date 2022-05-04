//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class FirebaseFireStoreUseCase {
    
    let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
    
    let profileExistenceObservable = PublishSubject<Bool>()
    
    func upLoadFirebaseUID(uid: String) {
        fireStoreManagerRepository.saveFirebaseUIDDocument(uid: uid)
    }
    
    func upLoadProfile(profile: ProfileDomainModel) {
        fireStoreManagerRepository.saveProfileDocument(profile: profile)
    }
    
    func getProfileExistence(uid: String) {
        fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) { profileExist in
            if profileExist {
                self.profileExistenceObservable.onNext(true)
            } else {
                self.profileExistenceObservable.onNext(false)
            }
        }
    }
}
