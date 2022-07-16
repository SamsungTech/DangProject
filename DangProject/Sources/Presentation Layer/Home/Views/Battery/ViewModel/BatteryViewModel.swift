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
    let totalSugarSumObservable: BehaviorRelay<Double> = BehaviorRelay(value: 0)
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        bindTodayEatenFoodsObservable()
    }
    
    private func bindTodayEatenFoodsObservable() {
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { [weak self] eatenFoodsPerDay in
                var totalSugarSum: Double = 0
                eatenFoodsPerDay.eatenFoods.forEach { eatenFood in
                    totalSugarSum = totalSugarSum + (Double(eatenFood.amount) * eatenFood.sugar)
                }
                self?.totalSugarSumObservable.accept(totalSugarSum.roundDecimal(to: 2))
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    
    
}
