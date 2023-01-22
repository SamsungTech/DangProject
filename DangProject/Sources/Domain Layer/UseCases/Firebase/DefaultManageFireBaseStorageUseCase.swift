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
    
    func getProfileImage() -> Observable<(NSData, Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.fireBaseStorageManagerRepository.getImageData()
                .subscribe(onNext: { nsData, bool in
                    if bool {
                        emitter.onNext((nsData, true))
                    } else {
                        emitter.onNext((NSData(), false))
                    }
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func uploadProfileImage(data: Data,
                            completion: @escaping(Bool)->Void) {
        fireBaseStorageManagerRepository.uploadImage(data, completion: completion)
    }
}
