//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/21.
//

import Foundation

class AddFoodsUseCase {
    
    let coreDataManagerRepository: CoreDataManagerRepository
    let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
    }
    
    func addEatenFoods(food: FoodDomainModel, currentDate: DateComponents) {
        coreDataManagerRepository.addFoods(food, at: CoreDataName.eatenFoods)
        firebaseFireStoreUseCase.upLoadEatenFood(eatenFood: food, currentDate: currentDate)
    }
}
