//
//  DefaultFireBaseStorageUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import Foundation

import RxSwift

class DefaultManageFireBaseStorageUseCase: ManageFirebaseStorageUseCase {
    
    private let fireBaseStorageManagerRepository: FireBaseStorageManagerRepository
    private let disposeBag = DisposeBag()
    private let uid = UserInfoKey.getUserDefaultsUID
    
    init(firebaseStorageManagerRepository: FireBaseStorageManagerRepository) {
        self.fireBaseStorageManagerRepository = firebaseStorageManagerRepository
    }
    
    func getProfileImage() -> Observable<NSData> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireBaseStorageManagerRepository.getImageData()
                .subscribe(onNext: { nsData in
                    emitter.onNext(nsData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func updateProfileImage(_ data: Data) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireBaseStorageManagerRepository.uploadImage(data)
                .subscribe(onNext: { isUploaded in
                    if isUploaded {
                        emitter.onNext(true)
                    } else {
                        emitter.onNext(false)
                    }
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
}
