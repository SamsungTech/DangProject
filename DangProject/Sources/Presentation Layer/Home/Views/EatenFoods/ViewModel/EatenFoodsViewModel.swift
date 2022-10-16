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
    private let profileManagerUseCase: ProfileManagerUseCase
    private var targetSugarRelay = BehaviorRelay<Int>(value: 0)
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManagerUseCase = profileManagerUseCase
        bindTodayEatenFoodsObservable()
        bindTargetSugar()
    }
    
    private func bindTargetSugar() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] profileData in
                self?.targetSugarRelay.accept(profileData.sugarLevel)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTodayEatenFoodsObservable() {
        // 로딩시작
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { [weak self] eatenFoodsPerDay in
                let data = eatenFoodsPerDay.eatenFoods.map{ EatenFoodsViewModelEntity.init($0) }
                
                self?.eatenFoodsViewModelObservable.accept(EatenFoodsPerDayViewModelEntity.init(date: eatenFoodsPerDay.date!, eatenFoods: data))
                // 로딩끝
            })
            .disposed(by: disposeBag)
    }
}
