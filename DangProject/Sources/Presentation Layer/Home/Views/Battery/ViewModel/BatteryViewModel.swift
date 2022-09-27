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
    let batteryEntityObservable: BehaviorRelay<(Double, Int)> = BehaviorRelay(value: (0.0, 0))
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let profileManagerUseCase: ProfileManagerUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManagerUseCase = profileManagerUseCase
        bindBatteryEntityObservable()
    }
    
    private func bindBatteryEntityObservable() {
        let totalSugarSumObservable = PublishSubject<Double>()
        let targetSugarObservable = PublishSubject<Int>()
        
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { eatenFoodsPerDay in
                var totalSugarSum: Double = 0
                eatenFoodsPerDay.eatenFoods.forEach { eatenFood in
                    totalSugarSum = totalSugarSum + (Double(eatenFood.amount) * eatenFood.sugar)
                }
                totalSugarSumObservable.onNext(totalSugarSum.roundDecimal(to: 2))
            })
            .disposed(by: disposeBag)
        
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { profileData in
                targetSugarObservable.onNext(profileData.sugarLevel)
            })
            .disposed(by: disposeBag)
        
        Observable.zip(totalSugarSumObservable, targetSugarObservable)
            .subscribe(onNext: { [weak self] totalSugarSum, targetSugar in
                self?.batteryEntityObservable.accept((totalSugarSum, targetSugar))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    
}
