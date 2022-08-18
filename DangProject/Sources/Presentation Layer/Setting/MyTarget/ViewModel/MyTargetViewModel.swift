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
    func setCurrentTargetSugar(_ data: Int)
    func fetchProfileData()
}

protocol MyTargetViewModelOutputProtocol: AnyObject {
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
}

protocol MyTargetViewModelProtocol: MyTargetViewModelInputProtocol, MyTargetViewModelOutputProtocol {}

class MyTargetViewModel: MyTargetViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fireStoreUseCase: ManageFirebaseFireStoreUseCase
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(fetchProfileUseCase: FetchProfileUseCase,
         fireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.fetchProfileUseCase = fetchProfileUseCase
        self.fireStoreUseCase = fireStoreUseCase
    }
    
    func setCurrentTargetSugar(_ data: Int) {
        let profileData = profileDataRelay.value
        let data = ProfileDomainModel.init(uid: "",
                                           name: profileData.name,
                                           height: profileData.height,
                                           weight: profileData.weight,
                                           sugarLevel: data,
                                           profileImage: profileData.profileImage,
                                           gender: profileData.gender,
                                           birthday: profileData.birthday)
        fireStoreUseCase.updateProfileData(data)
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept(profileData)
            })
            .disposed(by: disposeBag)
    }
}
