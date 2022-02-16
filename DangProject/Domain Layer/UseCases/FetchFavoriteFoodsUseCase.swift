//
//  FetchFavoriteFoods.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/15.
//

import Foundation

import RxSwift

class FetchFavoriteFoodsUseCase {
    
    let disposeBag = DisposeBag()
    
    func fetchFavoriteFoods() -> SearchFoodViewModel {
        let favoriteFoods = CoreDataManager.shared.loadFromCoreData(request: FavoriteFoods.fetchRequest())
        var tempFoodViewModel: [FoodViewModel] = []
        
        favoriteFoods.forEach {
            let favoriteFoodDomainModel = FoodDomainModel.init($0)
            tempFoodViewModel.append(FoodViewModel.init(favoriteFoodDomainModel))
        }
        return SearchFoodViewModel.init(keyWord: "", foodModels: tempFoodViewModel)
    }
}
