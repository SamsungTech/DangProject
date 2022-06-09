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
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: uid, ProfileExistence: false)
    }
    
    func uploadProfile(profile: ProfileDomainModel) {
        fireStoreManagerRepository.saveFirebaseUserDocument(uid: profile.uid, ProfileExistence: true)
        fireStoreManagerRepository.saveProfileDocument(profile: profile)
    }
    
    func getProfileExistence(uid: String) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            self?.fireStoreManagerRepository.checkProfileField(with: "profileExistence", uid: uid) {  profileExist in
                if profileExist {
                    emitter.onNext(true)
                } else {
                    emitter.onNext(false)
                }
            }
            return Disposables.create()
        }
        
    }
    
    func uploadEatenFood(eatenFood: FoodDomainModel, currentDate: DateComponents) {
        fireStoreManagerRepository.saveEatenFood(eatenFood: eatenFood, currentDate: currentDate)
    }
}
