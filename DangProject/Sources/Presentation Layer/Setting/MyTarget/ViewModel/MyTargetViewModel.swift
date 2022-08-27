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
        bindProfileData()
    }
    
    func setCurrentTargetSugar(_ data: Int) {
        let profileData = profileDataRelay.value
        let profileDomainData = ProfileDomainModel.init(uid: "",
                                           name: profileData.name,
                                           height: profileData.height,
                                           weight: profileData.weight,
                                           sugarLevel: data,
                                           profileImage: profileData.profileImage,
                                           gender: profileData.gender,
                                           birthday: profileData.birthday)
        fireStoreUseCase.updateProfileData(profileDomainData)
        
        fireStoreUseCase.getEatenFoods(dateComponents: DateComponents.currentDateTimeComponents())
            .subscribe(onNext: { [weak self] eatenFoods in
                if eatenFoods.count != 0 {
                    for i in eatenFoods {
                        var food = i
                        food.targetSugar = Double(data)
                        self?.fireStoreUseCase.uploadEatenFood(eatenFood: food)
                    }
                } else {
                    print("eatenFoods 데이터 없음")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
    }
    
    private func bindProfileData() {
        fetchProfileUseCase.profileDataSubject
            .subscribe(onNext: { [weak self] profileData in
                self?.profileDataRelay.accept(profileData)
            })
            .disposed(by: disposeBag)
    }
}
