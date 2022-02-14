//
//  ChangeFavoriteUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/09.
//
import Foundation

import RxSwift

class ChangeFavoriteUseCase {
    
    func changeFavorite(food: FoodDomainModel, completion: @escaping()->Void) {
        var tempFood = food
        tempFood.favorite = !food.favorite
            if food.favorite == false {
            CoreDataManager.shared.saveFavoriteFoods(food.foodCode)
        } else {
            CoreDataManager.shared.deleteFavoriteFood(at: food.foodCode, request: FavoriteFoods.fetchRequest())
        }
        completion()
    }
}
