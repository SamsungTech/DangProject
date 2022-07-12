//
//  EatenFoodsViewModelEntity.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

struct EatenFoodsViewModelEntity {
    let name: String
    var sugar: String
    var amount: String
    
    init(_ foodDomainModel: FoodDomainModel) {
        self.name = foodDomainModel.name
        self.sugar = String(foodDomainModel.sugar.roundDecimal(to: 2))
        self.amount = String(foodDomainModel.amount)
    }
}

struct EatenFoodsPerDayViewModelEntity {
    static let empty: Self = .init(date: Date.init(), eatenFoods: [])
    let date: Date
    let eatenFoods: [EatenFoodsViewModelEntity]
}
