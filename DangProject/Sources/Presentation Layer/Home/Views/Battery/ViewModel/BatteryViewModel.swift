//
//  BatteryViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/18.
//

import Foundation

import RxSwift
import RxRelay

class BatteryViewModel {
    private let disposeBag = DisposeBag()
    let totalSugarSumObservable: BehaviorRelay<(Double, Double)> = BehaviorRelay(value: (0.0,0.0))
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let profileManageUseCase: ProfileManagerUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManageUseCase: ProfileManagerUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManageUseCase = profileManageUseCase
        bindTodayEatenFoodsObservable()
    }
    
    private func bindTodayEatenFoodsObservable() {
        let fetchEatenFoodsObservable = PublishSubject<EatenFoodsPerDayDomainModel>()
        let profileDataObservable = PublishSubject<ProfileDomainModel>()
        
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { eatenFoodsPerDay in
                fetchEatenFoodsObservable.onNext(eatenFoodsPerDay)
            })
            .disposed(by: disposeBag)
        
        profileManageUseCase.fetchProfileData()
            .subscribe(onNext: { profileData in
                profileDataObservable.onNext(profileData)
            })
            .disposed(by: disposeBag)
        
        Observable.zip(fetchEatenFoodsObservable, profileDataObservable)
            .subscribe(onNext: { [weak self] eatenFoodsPerDay, profileData in
                var totalSugarSum: Double = 0
                eatenFoodsPerDay.eatenFoods.forEach { eatenFood in
                    totalSugarSum = totalSugarSum + (Double(eatenFood.amount) * eatenFood.sugar)
                }
                self?.totalSugarSumObservable.accept((totalSugarSum.roundDecimal(to: 2),
                                                      Double(profileData.sugarLevel)))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    
    
}
