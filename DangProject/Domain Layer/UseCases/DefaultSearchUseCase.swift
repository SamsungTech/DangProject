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
                self?.originalDomainFoodModels = foods
                self?.updateViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Internal
    var foodResultModelObservable = PublishSubject<SearchFoodViewModel>()
    
    func fetchFood(text: String) {
        currentKeyword = text
        fetchFoodRepository.fetchToDomainModel(text: text)
    }
    
    func updateViewModel() {
        // check favorites
        let checkedDomainFoodModels = checkFavorites()
        // updateViewModel
        foodResultModelObservable.onNext(SearchFoodViewModel.init(keyword: currentKeyword, foodModels: checkedDomainFoodModels.map{ FoodViewModel($0) }))
    }
    
    // MARK: - Private
    private var originalDomainFoodModels: [FoodDomainModel] = []
    private var currentKeyword = ""
    
    private func checkFavorites() -> [FoodDomainModel] {
        var currentDomainFoodModels: [FoodDomainModel] = []
        currentDomainFoodModels = originalDomainFoodModels
        
        let favoriteFoods = coreDataManagerRepository.loadFromCoreData(request: FavoriteFoods.fetchRequest())
        
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
