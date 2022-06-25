//
//  FetchEatenFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

import RxSwift

class DefaultFetchEatenFoodsUseCase: FetchEatenFoodsUseCase {
    let eatenFoodsObservable = PublishSubject<EatenFoodsPerDayDomainModel>()
    let previousCurrentNextMonthsDataObservable = PublishSubject<[[EatenFoodsPerDayDomainModel]]>()
    private let disposeBag = DisposeBag()

    
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
        fetchEatenFoods()
        fetchTotalMonthsData()
    }
    
    // MARK: - Internal
    func fetchTotalMonthsData(dateComponents: DateComponents = .currentDateTimeComponents()) {
        var previousDateComponents = dateComponents
        previousDateComponents.month = previousDateComponents.month! - 1
        var nextDateComponents = dateComponents
        nextDateComponents.month = nextDateComponents.month! + 1
        let current = fetchMonthData(dateComponents: dateComponents)
        let previous = fetchMonthData(dateComponents: previousDateComponents)
        let next = fetchMonthData(dateComponents: nextDateComponents)
        
        previousCurrentNextMonthsDataObservable.onNext([previous, current, next])
    }
    
    func fetchMonthData(dateComponents: DateComponents) -> [EatenFoodsPerDayDomainModel] {
        let daysCount: Int = .calculateDaysCount(year: dateComponents.year!, month: dateComponents.month!)
        var eatenFoods: [EatenFoodsPerDayDomainModel] = []
        for day in 1 ... daysCount {
            let tempDate: Date = .makeDate(year: dateComponents.year,
                                       month: dateComponents.month,
                                       day: day)
            let tempData = self.tempFetchEatenFoods(date: tempDate)
            eatenFoods.append(tempData)
        }
        return eatenFoods
    }
    
    func tempFetchEatenFoods(date: Date) -> EatenFoodsPerDayDomainModel {
        var tempData = EatenFoodsPerDayDomainModel.empty
        coreDataManagerRepository.checkEatenFoodsPerDay(date: date)
            .subscribe(onNext: { [weak self] eatenFoodNotExist, eatenFoodsPerDay in
                if eatenFoodNotExist {
                    // go to firebase
                } else {
                    tempData = EatenFoodsPerDayDomainModel.init(eatenFoodsPerDay)
                }
            })
            .disposed(by: disposeBag)
        return tempData
    }
    
    func fetchEatenFoods(date: Date = Date.currentDate()) {
        coreDataManagerRepository.checkEatenFoodsPerDay(date: date)
            .subscribe(onNext: { [weak self] eatenFoodNotExist, eatenFoodsPerDay in
                guard let strongSelf = self else { return }
                if eatenFoodNotExist {
                    // go to firebase
                    self?.eatenFoodsObservable.onNext(EatenFoodsPerDayDomainModel.empty) // 임시
                } else {
                    strongSelf.eatenFoodsObservable.onNext(EatenFoodsPerDayDomainModel.init(eatenFoodsPerDay))

                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private

}
