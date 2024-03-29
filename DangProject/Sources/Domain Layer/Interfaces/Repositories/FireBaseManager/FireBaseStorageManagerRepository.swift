//
//  FireBaseStorageManagerRepository.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import RxSwift
import Foundation

protocol FireBaseStorageManagerRepository {
    func uploadImage(_ image: Data,
                     completion: @escaping (Bool)->Void)
    func getImageData() -> Observable<(NSData, Bool)>
}
