//
//  DefaultFirebaseStorageManagerRepository.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import FirebaseStorage
import Foundation
import RxSwift

class DefaultFirebaseStorageManagerRepository: FireBaseStorageManagerRepository {
    private let uid = UserInfoKey.getUserDefaultsUID
    private let storage = Storage.storage()
    
    func getImageData() -> Observable<NSData> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.storage
                .reference(forURL: "gs://dangproject-443e0.appspot.com/"+"\(strongSelf.uid)"+"/profileImage.jpg")
                .downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        guard let url = url,
                              let data = NSData(contentsOf: url) else { return }
                        emitter.onNext(data)
                    }
            }
            return Disposables.create()
        }
    }
    
    func upLoadImage(_ image: Data) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        storage
            .reference()
            .child("\(self.uid)"+"/profileImage.jpg")
            .putData(image, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                } else {
                    print("프로필이미지 업로드 성공")
                }
        }
    }
}
