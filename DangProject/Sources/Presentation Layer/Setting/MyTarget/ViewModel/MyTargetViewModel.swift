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
    func fetchProfileData()
    func passTargetSugarForUpdate(_ targetSugar: Double, completion: @escaping (Bool) -> Void)
}

protocol MyTargetViewModelOutputProtocol: AnyObject {
    var targetSugarRelay: BehaviorRelay<Double> { get }
    var isTargetViewTextFieldRelay: BehaviorRelay<Bool> { get }
}

protocol MyTargetViewModelProtocol: MyTargetViewModelInputProtocol, MyTargetViewModelOutputProtocol {}

class MyTargetViewModel: MyTargetViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let profileManagerUseCase: ProfileManagerUseCase
    private var profileData: ProfileDomainModel = .empty
    var targetSugarRelay = BehaviorRelay<Double>(value: 0.0)
    var isTargetViewTextFieldRelay = BehaviorRelay<Bool>(value: true)
    
    init(profileManagerUseCase: ProfileManagerUseCase) {
        self.profileManagerUseCase = profileManagerUseCase
        self.bindProfileData()
    }
    
    func fetchProfileData() {
        profileManagerUseCase.fetchProfileData()
    }
    
    func checkCountZero(_ count: Int) {
        if count == 0 {
            isTargetViewTextFieldRelay.accept(false)
        } else {
            isTargetViewTextFieldRelay.accept(true)
        }
    }
    
    func passTargetSugarForUpdate(_ targetSugar: Double, completion: @escaping (Bool) -> Void) {
        let profileData: ProfileDomainModel = .init(uid: self.profileData.uid,
                                                    email: self.profileData.email,
                                                    name: self.profileData.name,
                                                    height: self.profileData.height,
                                                    weight: self.profileData.weight,
                                                    sugarLevel: Int(targetSugar),
                                                    profileImage: self.profileData.profileImage)
        profileManagerUseCase.saveProfileOnRemoteData(profileData, completion: completion)
    }
    
    private func bindProfileData() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profileData in
                self?.profileData = profileData
                self?.targetSugarRelay.accept(Double(profileData.sugarLevel))
            })
            .disposed(by: disposeBag)
    }
}
