//
//  FetchProfileUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import Foundation

import RxSwift

protocol FetchProfileUseCase {
    func fetchProfileImageData() -> Observable<Data>
    func fetchProfileData() -> Observable<ProfileDomainModel>
}
