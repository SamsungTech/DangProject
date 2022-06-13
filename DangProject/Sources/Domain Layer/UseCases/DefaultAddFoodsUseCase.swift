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
    private let firebaseFireStoreUseCase: FirebaseFireStoreUseCase
    
    init(coreDataManagerRepository: CoreDataManagerRepository,
         firebaseFireStoreUseCase: FirebaseFireStoreUseCase) {
        self.coreDataManagerRepository = coreDataManagerRepository
        self.firebaseFireStoreUseCase = firebaseFireStoreUseCase
    }
    
    // MARK: - Internal
    func addEatenFoods(food: FoodDomainModel) {
        uploadInFirebase(eatenFood: food)
        uploadInCoreData(eatenFood: food)
    }
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private func uploadInFirebase(eatenFood: FoodDomainModel) {
        firebaseFireStoreUseCase.getEatenFoods()
            .subscribe(onNext: { [weak self] addedFoodArr in
                var tempEatenFood = eatenFood
                addedFoodArr.forEach { addedFood in
                    if tempEatenFood.foodCode == addedFood.foodCode {
                        tempEatenFood.amount = tempEatenFood.amount + addedFood.amount
                    }
                }
                self?.firebaseFireStoreUseCase.uploadEatenFood(eatenFood: tempEatenFood)
            })
            .disposed(by: disposeBag)
    }
    
    private func uploadInCoreData(eatenFood: FoodDomainModel) {
        coreDataManagerRepository.checkEatenFoodsPerDay(request: EatenFoodsPerDay.fetchRequest())
            .subscribe(onNext: { [weak self] (isFirst, eatenFoodsPerDay) in
                if isFirst {
                    self?.coreDataManagerRepository.addEatenFood(food: eatenFood,
                                                                 eatenFoodsPerDayEntity: nil)
                } else {
                    guard let checkedFood = self?.checkEatenFoods(food: eatenFood,
                                                                  in: eatenFoodsPerDay.eatenFoodsArray) else { return }
                    self?.coreDataManagerRepository.addEatenFood(food: checkedFood,
                                                                 eatenFoodsPerDayEntity: eatenFoodsPerDay)
                    // Test
                    print(eatenFoodsPerDay.date)
                    eatenFoodsPerDay.eatenFoodsArray.forEach{
                        print($0.name, $0.amount)
                    }
                }
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
