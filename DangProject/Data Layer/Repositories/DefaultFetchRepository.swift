//
//  APIService.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class DefaultFetchRepository: FetchRepository {
  
    let fetchDataService: FetchDataService
    var foodDomainModelObservable = PublishSubject<[FoodDomainModel]>() 
    
    let disposeBag = DisposeBag()
    
    init(fetchDataService: FetchDataService) {
        self.fetchDataService = fetchDataService
        bindToFoodInfoObservable()
    }
    
    func fetchToDomainModel(text: String) {
        fetchDataService.fetchFoodEntity(text: text)
    }
    
    func bindToFoodInfoObservable() {
        fetchDataService.foodInfoObservable
            .subscribe(onNext: { [self] foods in
                let foodDomainModel = foods.map({ FoodDomainModel.init($0)})
                foodDomainModelObservable.onNext(foodDomainModel)
            })
            .disposed(by: disposeBag)
    }
}
