//
//  EatenFoodsViewModelEntity.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

struct EatenFoodsViewModelEntity {
//    static let empty: Self = .init(name: "", sugar: "", amount: "")
    let name: String
    var sugar: String
    var amount: String
    var totalSugar: String
    
    init(_ foodDomainModel: FoodDomainModel) {
        self.name = foodDomainModel.name
        self.sugar = String(foodDomainModel.sugar.roundDecimal(to: 2))
        self.amount = String(foodDomainModel.amount)
        self.totalSugar = String((foodDomainModel.sugar * Double(foodDomainModel.amount)).roundDecimal(to: 2))
    }
}

struct EatenFoodsPerDayViewModelEntity {
    static let empty: Self = .init(date: Date.init(), eatenFoods: [])
    let date: Date
    let eatenFoods: [EatenFoodsViewModelEntity]
}
