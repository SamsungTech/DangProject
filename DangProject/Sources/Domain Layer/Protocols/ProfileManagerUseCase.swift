//
//  ProfileManagerUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/07/21.
//

import Foundation

import RxSwift

protocol ProfileManagerUseCase {
    func fetchProfileData()
    func saveProfileOnRemoteData(_ profile: ProfileDomainModel, completion: @escaping (Bool) -> Void)
    
    var profileDataObservable: PublishSubject<ProfileDomainModel> { get }
}
