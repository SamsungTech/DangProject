//
//  APIService.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class DefaultFetchRepository: FetchRepository {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let fetchDataService: FetchDataService
    
    init(fetchDataService: FetchDataService) {
        self.fetchDataService = fetchDataService
        bindToFoodInfoObservable()
    }
    
    private func bindToFoodInfoObservable() {
        fetchDataService.foodInfoObservable
            .subscribe(onNext: { [self] foodEntity in
                foodDomainModelObservable.onNext(SearchResultDomainModel.init(foodEntity))
            })
            .disposed(by: disposeBag)
    }
    // MARK: - Internal
    var foodDomainModelObservable = PublishSubject<SearchResultDomainModel>()
    var foodDomainModelErrorObservable = PublishSubject<String>()
    
    func fetchToDomainModel(text: String, completion: @escaping(Bool)->Void) {
        fetchDataService.fetchFoodEntity(text: text, completion: completion)
    }
}
