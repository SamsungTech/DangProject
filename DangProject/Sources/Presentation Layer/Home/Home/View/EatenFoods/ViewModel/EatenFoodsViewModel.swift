//
//  EatenFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

import RxSwift
import RxRelay

class EatenFoodsViewModel {
    private let disposeBag = DisposeBag()
    let eatenFoodsViewModelObservable: BehaviorRelay<EatenFoodsPerDayViewModelEntity> = BehaviorRelay(value: EatenFoodsPerDayViewModelEntity.empty)
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        bindTodayEatenFoodsObservable()
    }
    
    private func bindTodayEatenFoodsObservable() {
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { [weak self] eatenFoodsPerDay in
                let data = eatenFoodsPerDay.eatenFoods.map{ EatenFoodsViewModelEntity.init($0) }
                
                self?.eatenFoodsViewModelObservable.accept(EatenFoodsPerDayViewModelEntity.init(date: eatenFoodsPerDay.date!, eatenFoods: data))
            })
            .disposed(by: disposeBag)
    }
}
