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
    let totalSugarSumObservable: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    let profileSugarLevelObservable: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    let batteryDataObservable: BehaviorRelay<(Double, Double)> = BehaviorRelay(value: (0.0, 0.0))
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let profileManageUseCase: ProfileManagerUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManageUseCase: ProfileManagerUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManageUseCase = profileManageUseCase
        bindTodayEatenFoodsObservable()
    }
    
    // MARK: 한번은 다같이 데이터 보내기, 두번째부턴 각각의 데이터 변경사항에 맞게 보내기
    // MARK: 
    
    
    private func bindTodayEatenFoodsObservable() {
        let totalSugarSumObservable = PublishSubject<Double>()
        let profileSugarLevelObservable = PublishSubject<Double>()
        
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { eatenFoodsPerDay in
                var totalSugarSum: Double = 0
                eatenFoodsPerDay.eatenFoods.forEach { eatenFood in
                    totalSugarSum = totalSugarSum + (Double(eatenFood.amount) * eatenFood.sugar)
                }
                totalSugarSumObservable.onNext(totalSugarSum.roundDecimal(to: 2))
            })
            .disposed(by: disposeBag)
        
        profileManageUseCase.profileDataObservable
            .subscribe(onNext: { profileData in
                profileSugarLevelObservable.onNext(Double(profileData.sugarLevel))
            })
            .disposed(by: disposeBag)
        
        Observable.zip(totalSugarSumObservable, profileSugarLevelObservable)
            .subscribe(onNext: { [weak self] totalSugarSum, profileSugarLevel in
                self?.batteryDataObservable.accept((totalSugarSum, profileSugarLevel))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    
    
}
