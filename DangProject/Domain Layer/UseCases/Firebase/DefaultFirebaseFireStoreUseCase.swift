//
//  FirebaseFireStoreManager.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/02.
//

import Foundation

import RxSwift

class DefaultFirebaseFireStoreUseCase: FirebaseFireStoreUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fireStoreManagerRepository: FireStoreManagerRepository
    
    init(fireStoreManagerRepository: FireStoreManagerRepository) {
        self.fireStoreManagerRepository = fireStoreManagerRepository
    }
    
    // MARK: - Internal
    let profileExistenceObservable = PublishSubject<Bool>()
    
    func uploadFirebaseUID(uid: String) {
        fireStoreManagerRepository.saveFirebaseUIDDocument(uid: uid)
    }
    
    func uploadProfile(profile: ProfileDomainModel) {
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
    
    func uploadEatenFood(eatenFood: FoodDomainModel, currentDate: DateComponents) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood, currentDate: currentDate)
    }
}
