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
    
    var currentDomainFoodModels: [FoodDomainModel] = []
    var foodResultModelObservable = PublishSubject<SearchFoodViewModel>()
    var currentKeyword = ""
    
    let disposeBag = DisposeBag()
    
    init(fetchFoodRepository: FetchRepository) {
        self.fetchFoodRepository = fetchFoodRepository
        bindToFoodDomainModelObservable()
    }
    
    func searchFood(text: String) {
        currentKeyword = text
        fetchFoodRepository.fetchToDomainModel(text: text)
    }
    
    func bindToFoodDomainModelObservable() {
        fetchFoodRepository.foodDomainModelObservable
            .subscribe(onNext: { [self] foods in
                currentDomainFoodModels = foods
                
                updateViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    func updateViewModel() {
//check favorites
        let favoriteFoods = CoreDataManager.shared.loadFromCoreData(request: FavoriteFoods.fetchRequest())
        
        favoriteFoods.forEach { favoriteFood in
            currentDomainFoodModels.forEach { food in
                if favoriteFood.foodCode == food.foodCode {
                    var tempFood: FoodDomainModel = food
                    tempFood.favorite = true
                    if let index = currentDomainFoodModels.firstIndex(of: food) {
                        currentDomainFoodModels[index] = tempFood
                    }
                }
            }
        }
        
        
        
        foodResultModelObservable.onNext(SearchFoodViewModel.init(keyWord: currentKeyword, foodModels: currentDomainFoodModels))
    }
}
