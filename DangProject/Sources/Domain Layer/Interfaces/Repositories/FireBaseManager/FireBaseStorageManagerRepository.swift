//
//  FireBaseStorageManagerRepository.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import RxSwift
import Foundation

protocol FireBaseStorageManagerRepository {
    func upLoadImage(_ image: Data)
    func getImageData() -> Observable<NSData>
}
