//
//  ChangeFavoriteUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/09.
//
import Foundation

class DefaultChangeFavoriteUseCase: ChangeFavoriteUseCase {
    
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    // MARK: - Internal
    func changeFavorite(food: FoodDomainModel) {
        if food.favorite == false {
            coreDataManagerRepository.addFavoriteFood(food: food)
        } else {
            coreDataManagerRepository.deleteFavoriteFood(at: food.foodCode, request: FavoriteFoods.fetchRequest())
        }
    }
}
