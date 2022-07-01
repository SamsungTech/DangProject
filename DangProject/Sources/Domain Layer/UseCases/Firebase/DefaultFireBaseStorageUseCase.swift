//
//  DefaultFireBaseStorageUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import Foundation
import RxSwift

class DefaultFireBaseStorageUseCase: FirebaseStorageUseCase {
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
                .subscribe(onNext: { [weak self] nsData in
                    emitter.onNext(nsData)
                })
                .disposed(by: strongSelf.disposeBag)
            return Disposables.create()
        }
    }
    
    func upDateProfileImage(_ data: Data) {
        fireBaseStorageManagerRepository.upLoadImage(data)
    }
}
