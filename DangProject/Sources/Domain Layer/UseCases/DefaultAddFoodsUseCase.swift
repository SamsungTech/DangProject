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
    func addEatenFoods(food: FoodDomainModel, currentDate: DateComponents) {
        guard let uid = UserDefaults.standard.string(forKey: UserInfoKey.firebaseUID) else { return }
        firebaseFireStoreUseCase.getEatenFoods(uid: uid, date: currentDate)
            .subscribe(onNext: { [weak self] addedFoodArr in
                var eatenFood = food
                addedFoodArr.forEach { addedFood in
                    if eatenFood.foodCode == addedFood.foodCode {
                        eatenFood.amount = eatenFood.amount + addedFood.amount
                    }
                }
                self?.firebaseFireStoreUseCase.uploadEatenFood(eatenFood: eatenFood, currentDate: currentDate)
            })
            .disposed(by: disposeBag)
        
        coreDataManagerRepository.addFoods(food, at: CoreDataName.eatenFoods)
    }
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
}
