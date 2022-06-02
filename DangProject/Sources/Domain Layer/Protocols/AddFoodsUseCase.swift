//
//  AddFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/16.
//

import Foundation

protocol AddFoodsUseCase {
    func addEatenFoods(food: FoodDomainModel, currentDate: DateComponents)
}
