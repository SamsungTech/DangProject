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
    
    func getImageData() -> Observable<(NSData, Bool)> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            self?.storage
                .reference(forURL: "gs://dangproject-443e0.appspot.com/"+"\(strongSelf.uid)"+"/profileImage.jpg")
                .downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        emitter.onNext((NSData(), false))
                        return
                    } else {
                        guard let url = url else { return }
                        
                        DispatchQueue.global().async {
                            guard let data = NSData(contentsOf: url) else { return }
                            emitter.onNext((data, true))
                        }
                    }
            }
            return Disposables.create()
        }
    }
    
    func uploadImage(_ image: Data,
                     completion: @escaping (Bool)->Void) {
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        self.storage
            .reference()
            .child("\(String(describing: self.uid))"+"/profileImage.jpg")
            .putData(image, metadata: metaData) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                    print("프로필이미지 업로드 실패")
                    completion(false)
                    return
                } else {
                    completion(true)
                }
            }
    }
}
