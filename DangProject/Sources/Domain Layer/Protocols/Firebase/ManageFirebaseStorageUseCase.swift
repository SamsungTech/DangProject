//
//  FirebaseStorageUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/01.
//

import Foundation
import RxSwift

protocol ManageFirebaseStorageUseCase {
    func getProfileImage() -> Observable<(NSData, Bool)>
    func uploadProfileImage(data: Data, completion: @escaping(Bool)->Void)
}
