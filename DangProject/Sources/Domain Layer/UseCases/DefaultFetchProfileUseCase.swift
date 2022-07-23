//
//  DefaultFetchProfileUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import Foundation

import RxSwift

class DefaultFetchProfileUseCase: FetchProfileUseCase {
    private let disposeBag = DisposeBag()
    private var coreDataManagerRepository: CoreDataManagerRepository
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    private var isLatestData: Bool = false
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
    }
    
    func fetchProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            if strongSelf.isLatestData != true {
                strongSelf.fetchRemoteProfileData()
                    .subscribe(onNext: { profileData in
                        emitter.onNext(profileData)
                    })
                    .disposed(by: strongSelf.disposeBag)
            } else {
                strongSelf.fetchLocalProfileData()
                    .subscribe(onNext: { profileData in
                        emitter.onNext(profileData)
                    })
                    .disposed(by: strongSelf.disposeBag)
            }
            return Disposables.create()
        }
    }
    
    func fetchRemoteProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
                
            self?.firebaseFireStoreUseCase.getProfileData()
                .subscribe(onNext: { profileData in
                    self?.coreDataManagerRepository.updateLocalProfileData(profileData)
                    emitter.onNext(profileData)
                    strongSelf.isLatestData = true
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func fetchLocalProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            if let result = self?.coreDataManagerRepository.fetchProfileEntityData {
                emitter.onNext(ProfileDomainModel.init(profileEntity: result()))
            }
            return Disposables.create()
        }
    }
}
