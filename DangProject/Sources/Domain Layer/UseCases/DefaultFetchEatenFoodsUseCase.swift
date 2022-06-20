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
    
    private let disposeBag = DisposeBag()

    
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
        fetchEatenFoods(date: Date.currentDate())
    }
    
    // MARK: - Internal
    func fetchEatenFoods(date: Date) {
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
