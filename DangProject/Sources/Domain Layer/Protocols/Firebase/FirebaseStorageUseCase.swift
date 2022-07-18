//
//  FirebaseStorageUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import Foundation
import RxSwift

protocol FirebaseStorageUseCase {
    func getProfileImage() -> Observable<NSData>
    func updateProfileImage(_ data: Data)
}
