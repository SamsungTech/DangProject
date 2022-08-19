//
//  ProfileManagerUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import Foundation

import RxSwift

protocol ProfileManagerUseCase {
    func fetchProfileData() -> Observable<ProfileDomainModel>
    func saveProfileOnCoreData(_ profile: ProfileDomainModel)
}
