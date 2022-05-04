//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/21.
//

import Foundation

class AddFoodsUseCase {
    
    let coreDataManagerRepository: CoreDataManagerRepository
    
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
    }
    
    func addEatenFoods(food: FoodDomainModel) {
        coreDataManagerRepository.addFoods(food, at: CoreDataName.eatenFoods)
    }
}
