//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/21.
//

import Foundation

class AddFoodsUseCase {
    func addEatenFoods(food: FoodDomainModel) {
        CoreDataManager.shared.addFoods(food, at: CoreDataName.eatenFoods)
    }
}
