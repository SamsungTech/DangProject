//
//  SearchFoodUsecase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

import RxSwift

class SearchUseCase {
    
    let fetchFoodRepository: FetchRepository
    let coreDataManagerRepository: CoreDataManagerRepository
    
    var originalDomainFoodModels: [FoodDomainModel] = []
    var foodResultModelObservable = PublishSubject<SearchFoodViewModel>()
    var currentKeyword = ""
    
    let disposeBag = DisposeBag()
    
    init(fetchFoodRepository: FetchRepository,
         coreDataManagerRepository: CoreDataManagerRepository) {
        self.fetchFoodRepository = fetchFoodRepository
        self.coreDataManagerRepository = coreDataManagerRepository
        bindToFoodDomainModelObservable()
    }
    
    func fetchFood(text: String) {
        currentKeyword = text
        fetchFoodRepository.fetchToDomainModel(text: text)
    }
    
    private func bindToFoodDomainModelObservable() {
        fetchFoodRepository.foodDomainModelObservable
            .subscribe(onNext: { [self] foods in
                originalDomainFoodModels = foods
                updateViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    func checkFavorites() -> [FoodDomainModel] {
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
    
    func updateViewModel() {
        //check favorites
        let checkedDomainFoodModels = checkFavorites()
        // updateViewModel
        foodResultModelObservable.onNext(SearchFoodViewModel.init(keyword: currentKeyword, foodModels: checkedDomainFoodModels.map{ FoodViewModel($0) }))
    }
}
