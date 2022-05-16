//
//  FetchFavoriteFoods.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/15.
//

import Foundation

import RxSwift

class FetchFavoriteFoodsUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    // MARK: - Internal
    func fetchFavoriteFoods() -> SearchFoodViewModel {
        let favoriteFoods = coreDataManagerRepository.loadFromCoreData(request: FavoriteFoods.fetchRequest())
        var tempFoodViewModel: [FoodViewModel] = []
        
        favoriteFoods.forEach {
            let favoriteFoodDomainModel = FoodDomainModel.init($0)
            tempFoodViewModel.append(FoodViewModel.init(favoriteFoodDomainModel))
        }
        return SearchFoodViewModel.init(keyword: "", foodModels: tempFoodViewModel)
    }
    
    func delete() {
        coreDataManagerRepository.deleteAll(request: FavoriteFoods.fetchRequest())
    }
}
