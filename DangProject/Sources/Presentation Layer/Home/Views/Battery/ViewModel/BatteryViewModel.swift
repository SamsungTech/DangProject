//
//  BatteryViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/18.
//

import Foundation

import RxSwift
import RxRelay

struct BatteryEntity {
    static let empty: Self = .init(totalSugarSum: 0.0,
                                   targetSugar: 0)
    var totalSugarSum: Double
    var targetSugar: Int
}

class BatteryViewModel {
    private let disposeBag = DisposeBag()
    let batteryEntityObservable: BehaviorRelay<BatteryEntity> = BehaviorRelay(value: .empty)
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         fetchProfileUseCase: FetchProfileUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        bindBatteryEntityObservable()
    }
    
    // MARK: - Internal
    private func bindBatteryEntityObservable() {
        let eatenFoodsObservable = PublishSubject<EatenFoodsPerDayDomainModel>()
        let profileObservable = PublishSubject<ProfileDomainModel>()
        
        fetchEatenFoodsUseCase.eatenFoodsObservable
            .subscribe(onNext: { eatenFoods in
                eatenFoodsObservable.onNext(eatenFoods)
            })
            .disposed(by: disposeBag)
        
        fetchProfileUseCase.profileDataSubject
            .subscribe(onNext: { profileData in
                profileObservable.onNext(profileData)
            })
            .disposed(by: disposeBag)

        Observable.zip(eatenFoodsObservable, profileObservable)
            .subscribe(onNext: { [weak self] eatenFoodsPerDay, profileData in
                var totalSugarSum: Double = 0
                eatenFoodsPerDay.eatenFoods.forEach { eatenFood in
                    totalSugarSum = totalSugarSum + (Double(eatenFood.amount) * eatenFood.sugar)
                }
                
                let batteryEntity = BatteryEntity.init(totalSugarSum: totalSugarSum.roundDecimal(to: 2),
                                                       targetSugar: profileData.sugarLevel)
                self?.batteryEntityObservable.accept(batteryEntity)
            })
            .disposed(by: disposeBag)
    }
}
