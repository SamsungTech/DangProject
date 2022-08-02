//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/21.
//

import Foundation

import RxSwift

class DefaultAddFoodsUseCase: AddFoodsUseCase {
    // MARK: - Init
    private let coreDataManagerRepository: CoreDataManagerRepository
    private let firebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: ManageFirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
    }
    
    // MARK: - Internal
    func addEatenFoods(food: FoodDomainModel) {
        uploadInFirebase(eatenFood: food)
    }
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private func uploadInFirebase(eatenFood: FoodDomainModel) {
        firebaseFireStoreUseCase.getEatenFoods(dateComponents: .currentDateTimeComponents())
            .subscribe(onNext: { [weak self] addedFoodArr in
                var tempEatenFood = eatenFood 
                addedFoodArr.forEach { addedFood in
                    if tempEatenFood.foodCode == addedFood.foodCode {
                        tempEatenFood.amount = tempEatenFood.amount + addedFood.amount
                        tempEatenFood.eatenTime = addedFood.eatenTime
                    }
                }
                self?.firebaseFireStoreUseCase.uploadEatenFood(eatenFood: tempEatenFood)
            })
            .disposed(by: disposeBag)
    }
    
    private func checkEatenFoods(food: FoodDomainModel,
                                        in eatenFoodsArray: [EatenFoods]) -> FoodDomainModel {
        var tempFood = food
        for i in 0 ..< eatenFoodsArray.count {
            if tempFood.foodCode == eatenFoodsArray[i].foodCode {
                tempFood.amount = tempFood.amount + Int(eatenFoodsArray[i].amount)
            }
        }
        return tempFood
    }
}
