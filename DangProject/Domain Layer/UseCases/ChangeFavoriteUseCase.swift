//
//  ChangeFavoriteUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/09.
//
import Foundation

import RxSwift

class ChangeFavoriteUseCase {
    
    let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    func changeFavorite(food: FoodDomainModel, completion: @escaping()->Void) {
        var tempFood = food
        tempFood.favorite = !food.favorite
        if food.favorite == false {
            coreDataManagerRepository.addFoods(food, at: CoreDataName.favoriteFoods)
        }
        else {
            coreDataManagerRepository.deleteFavoriteFood(at: food.foodCode, request: FavoriteFoods.fetchRequest())
        }
        completion()
    }
}
