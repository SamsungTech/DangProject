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
    private var urlSession = URLSession.shared
    
    func getImageData() -> Observable<NSData> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            
            strongSelf.getImageDataFromStorage { result in
                switch result {
                case .success(let data):
                    emitter.onNext(data)
                case .failure(let error):
                    emitter.onError(error)
                    emitter.onCompleted()
                }
                
            }
            return Disposables.create()
        }
    }
    
    func uploadImage(_ image: Data) -> Observable<Bool> {
        return Observable.create { [weak self] emitter in
            guard let strongSelf = self else { return Disposables.create() }
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            self?.storage
                .reference()
                .child("\(String(describing: strongSelf.uid))"+"/profileImage.jpg")
                .putData(image, metadata: metaData) { (metaData, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        emitter.onNext(false)
                        return
                    } else {
                        print("프로필이미지 업로드 성공")
                        emitter.onNext(true)
                    }
                }
            return Disposables.create()
        }
    }
    
    private func getImageDataFromStorage(onComplete: @escaping ((Result<NSData, Error>) -> Void)) {
        self.storage
            .reference(forURL: "gs://dangproject-443e0.appspot.com/"+"\(uid)"+"/profileImage.jpg")
            .downloadURL { (url, error) in
                if let error = error {
                    onComplete(.failure(error))
                    return
                }
                guard let url = url else { return }
                self.fetchNSData(url: url) { result in
                    onComplete(.success(result))
                    
                }
            }
    }
    
    private func fetchNSData(url: URL,
                             onComplete: @escaping ((NSData) -> Void)) {
        DispatchQueue.main.async {
            guard let data = NSData(contentsOf: url) else {
                return
            }
            onComplete(data)
        }
    }
}
