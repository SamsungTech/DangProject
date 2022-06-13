//
//  FetchFavoriteFoods.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/15.
//

import Foundation

import RxSwift

class DefaultFetchFavoriteFoodsUseCase: FetchFavoriteFoodsUseCase {
    private let disposeBag = DisposeBag()
    
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    // MARK: - Internal
    func fetchFavoriteFoods() -> [FoodViewModel] {
        let favoriteFoodsRequest = FavoriteFoods.fetchRequest()
        let favoriteFoods = coreDataManagerRepository.loadFromCoreData(request: favoriteFoodsRequest)
        var favoriteFoodViewModel: [FoodViewModel] = []
        
        favoriteFoods.forEach {
            let favoriteFoodDomainModel = FoodDomainModel.init($0)
            favoriteFoodViewModel.append(FoodViewModel.init(favoriteFoodDomainModel))
        }
        return favoriteFoodViewModel
    }
}
