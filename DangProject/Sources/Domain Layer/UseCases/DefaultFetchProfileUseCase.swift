//
//  DefaultFetchProfileUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import UIKit

import RxSwift

class DefaultFetchProfileUseCase: FetchProfileUseCase {
    private let disposeBag = DisposeBag()
    private var coreDataManagerRepository: CoreDataManagerRepository
    private let manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.manageFirebaseFireStoreUseCase = manageFirebaseFireStoreUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
    }
    
    func fetchProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            if ProfileDomainModel.isLatestProfileDataValue {
                strongSelf.fetchLocalProfileData()
                    .subscribe(onNext: { profileData in
                        emitter.onNext(profileData)
                    })
                    .disposed(by: strongSelf.disposeBag)
            } else {
                strongSelf.fetchRemoteProfileData()
                    .subscribe(onNext: { profileData in
                        emitter.onNext(profileData)
                    })
                    .disposed(by: strongSelf.disposeBag)
                ProfileDomainModel.setIsLatestProfileData(true)
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Private
    private func fetchRemoteProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self,
                  let profileImage = self?.manageFirebaseStorageUseCase.getProfileImage(),
                  let profileData = self?.manageFirebaseFireStoreUseCase.getProfileData() else { return Disposables.create() }
            
            Observable.combineLatest(profileImage, profileData)
                .subscribe(onNext: { profileImageData, profileData in
                    guard let image = UIImage(data: profileImageData as Data) else { return }
                    var profileData: ProfileDomainModel = profileData
                    profileData.profileImage = image
                    self?.coreDataManagerRepository.updateLocalProfileData(profileData)
                    emitter.onNext(profileData)
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func fetchLocalProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let result = self?.coreDataManagerRepository.fetchProfileEntityData() else { return Disposables.create() }
            let profileData = ProfileDomainModel(result)
            emitter.onNext(profileData)
            return Disposables.create()
        }
    }
}
