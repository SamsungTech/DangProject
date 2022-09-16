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
        // 로딩시작
        
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { [weak self] eatenFoodsPerDay in
                guard let date = eatenFoodsPerDay.date else {
                    return
                    
                }
                let data = eatenFoodsPerDay.eatenFoods.map{ EatenFoodsViewModelEntity.init($0) }
                self?.eatenFoodsViewModelObservable.accept(EatenFoodsPerDayViewModelEntity.init(date: date, eatenFoods: data))
                
                // 로딩끝
            })
            .disposed(by: disposeBag)
        
    }
}
