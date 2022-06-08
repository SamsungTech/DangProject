//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/21.
//

import Foundation

class DefaultAddFoodsUseCase: AddFoodsUseCase {
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
    }
    
    // MARK: - Internal
    func addEatenFoods(food: FoodDomainModel, currentDate: DateComponents) {
        // 여기서 음식 추가 할때 중복된 데이터 확인
//        
//        
//        let value = firebaseFireStoreUseCase.getData()
//        
//        value.forEach {
//            if $0.foodCode == food.foodCode {
//                // 수량만 올린다.
//            } else {
//                
//            }
//        }
        
        coreDataManagerRepository.addFoods(food, at: CoreDataName.eatenFoods)
        firebaseFireStoreUseCase.uploadEatenFood(eatenFood: food, currentDate: currentDate)
    }
}
