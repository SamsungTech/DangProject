//
//  SearchFoodUsecase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class DefaultSearchUseCase: SearchUseCase {
    private let disposeBag = DisposeBag()
    // MARK: - Init
    private let fetchFoodRepository: FetchRepository
    private let coreDataManagerRepository: CoreDataManagerRepository
    
    init(fetchFoodRepository: FetchRepository,
         coreDataManagerRepository: CoreDataManagerRepository) {
        self.fetchFoodRepository = fetchFoodRepository
        self.coreDataManagerRepository = coreDataManagerRepository
        bindToFoodDomainModelObservable()
    }
    
    private func bindToFoodDomainModelObservable() {
        fetchFoodRepository.foodDomainModelObservable
            .subscribe(onNext: { [weak self] foods in
                guard let strongSelf = self else { return }
                guard foods.code == "INFO-000" else {
                    return strongSelf.foodResultModelObservable.onNext([])
                }
                if foods.keyword == self?.currentKeyword {
                    self?.originalDomainFoodModels = foods.foodDomainModel
                }
                self?.updateViewModel(keyword: foods.keyword)
            })
            .disposed(by: disposeBag)
        
        fetchFoodRepository.foodDomainModelErrorObservable
            .subscribe(onNext: { [weak self] error in
                self?.searchErrorObservable.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    var foodResultModelObservable = PublishSubject<[FoodViewModel]>()
    var searchErrorObservable = PublishSubject<String>()
    
    func fetchFood(text: String) {
        currentKeyword = text
        fetchFoodRepository.fetchToDomainModel(text: text)
    }
    
    func updateViewModel(keyword: String?) {
        // check favorites
        let checkedDomainFoodModels = checkFavorites()
        // updateViewModel
        foodResultModelObservable.onNext(checkedDomainFoodModels.map{ FoodViewModel.init($0)})
    }
    
    // MARK: - Private
    private var originalDomainFoodModels: [FoodDomainModel] = []
    private var currentKeyword = ""
    
    private func checkFavorites() -> [FoodDomainModel] {
        var currentDomainFoodModels = originalDomainFoodModels
        let favoriteFoods = coreDataManagerRepository.fetchCoreDataArray(from: .favoriteFoods).map{ $0 as? FavoriteFoods ?? FavoriteFoods.init() }
        
        originalDomainFoodModels.forEach { food in
            favoriteFoods.forEach { favoriteFood in
                guard let favoriteFoodCode = favoriteFood.foodCode else
                { return }
                if food.foodCode == favoriteFoodCode {
                    var tempFood = food
                    tempFood.favorite = true
                    if let index = currentDomainFoodModels.firstIndex(of: food) {
                        currentDomainFoodModels[index] = tempFood
                    }
                }
                
            }
        }
        return currentDomainFoodModels
    }
}
