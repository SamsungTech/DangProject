//
//  MyTargetViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/18.
//

import Foundation
import RxSwift
import RxRelay

protocol MyTargetViewModelInputProtocol: AnyObject {
    func fetchSugarLevel()
    func saveTargetSugarLevel(_ data: Double)
}

protocol MyTargetViewModelOutputProtocol: AnyObject {
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
}

protocol MyTargetViewModelProtocol: MyTargetViewModelInputProtocol, MyTargetViewModelOutputProtocol {}

class MyTargetViewModel: MyTargetViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let profileManageUseCase: ProfileManagerUseCase
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(profileManageUseCase: ProfileManagerUseCase) {
        self.profileManageUseCase = profileManageUseCase
        self.bindSugarLevel()
    }
    
    func fetchSugarLevel() {
        profileManageUseCase.fetchProfileData()
    }
    
    func saveTargetSugarLevel(_ data: Double) {
        let profileData: ProfileDomainModel = .init(uid: profileDataRelay.value.uid,
                                                    name: profileDataRelay.value.name,
                                                    height: profileDataRelay.value.height,
                                                    weight: profileDataRelay.value.weight,
                                                    sugarLevel: Int(data),
                                                    profileImage: profileDataRelay.value.profileImage,
                                                    gender: profileDataRelay.value.gender,
                                                    birthday: profileDataRelay.value.birthday)
        profileManageUseCase.saveProfileOnCoreData(profileData)
    }
    
    private func bindSugarLevel() {
        profileManageUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept(profileData)
            })
            .disposed(by: disposeBag)
    }
}
