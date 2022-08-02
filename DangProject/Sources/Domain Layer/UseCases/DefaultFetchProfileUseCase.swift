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
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
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
    
    func fetchProfileImageData() -> Observable<Data> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            if ProfileDomainModel.isLatestProfileImageDataValue {
                strongSelf.fetchLocalProfileImageData()
                    .subscribe(onNext: { imageData in
                        emitter.onNext(imageData)
                    })
                    .disposed(by: strongSelf.disposeBag)
            } else {
                strongSelf.fetchRemoteProfileImageData()
                    .subscribe(onNext: { imageData in
                        emitter.onNext(imageData)
                    })
                    .disposed(by: strongSelf.disposeBag)
                ProfileDomainModel.setIsLatestProfileImageData(true)
            }
            return Disposables.create()
        }
    }
    
    // MARK: - Private
    private func fetchRemoteProfileData() -> Observable<ProfileDomainModel> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self,
                  let profileImage = self?.manageFirebaseStorageUseCase.getProfileImage(),
                  let profileData = self?.firebaseFireStoreUseCase.getProfileData() else { return Disposables.create() }
            
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
            guard let result = self?.coreDataManagerRepository.fetchProfileEntityData(),
                  let profileData = ProfileDomainModel.init(profileEntity: result) else { return Disposables.create() }
            emitter.onNext(profileData)
            return Disposables.create()
        }
    }
    
    private func fetchRemoteProfileImageData() -> Observable<Data> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self,
                  let profileImage = self?.manageFirebaseStorageUseCase.getProfileImage(),
                  let profileData = self?.firebaseFireStoreUseCase.getProfileData() else { return Disposables.create() }
            
            Observable.combineLatest(profileImage, profileData)
                .subscribe(onNext: { profileImage, profileData in
                    guard let profileImageData = UIImage(data: profileImage as Data) else { return }
                    strongSelf.coreDataManagerRepository.updateProfileImageData(profileImageData,profileData)
                    emitter.onNext(profileImage as Data)
                })
                .disposed(by: strongSelf.disposeBag)
            
            return Disposables.create()
        }
    }
    
    private func fetchLocalProfileImageData() -> Observable<Data> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            let profileImageData = strongSelf.coreDataManagerRepository.fetchProfileImageData()
            emitter.onNext(profileImageData)
            return Disposables.create()
        }
    }
}
