//
//  DefaultProfileManagerUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import UIKit

import RxSwift

class DefaultProfileManagerUseCase: ProfileManagerUseCase {
    private let disposeBag = DisposeBag()
    private var coreDataManagerRepository: CoreDataManagerRepository
    private let manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    private let manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase
    
    var profileDataObservable = PublishSubject<ProfileDomainModel>()
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         manageFirebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase,
         manageFirebaseStorageUseCase: ManageFirebaseStorageUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.manageFirebaseFireStoreUseCase = manageFirebaseFireStoreUseCase
        self.manageFirebaseStorageUseCase = manageFirebaseStorageUseCase
    }
    
    func fetchProfileData() {
        if ProfileDomainModel.isLatestProfileDataValue {
            fetchLocalProfileData()
                .subscribe(onNext: { [weak self] profileData in
                    self?.profileDataObservable.onNext(profileData)
                })
                .disposed(by: disposeBag)
        } else {
            fetchRemoteProfileData()
                .subscribe(onNext: { [weak self] profileData in
                    self?.profileDataObservable.onNext(profileData)
                })
                .disposed(by: disposeBag)
            ProfileDomainModel.setIsLatestProfileData(true)
        }
    }
    
    func saveProfileOnCoreData(_ profile: ProfileDomainModel) {
        coreDataManagerRepository.updateProfileData(profile)
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
                    self?.coreDataManagerRepository.updateProfileData(profileData)
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
