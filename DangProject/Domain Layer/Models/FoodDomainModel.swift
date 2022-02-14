//
//  FoodDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

struct FoodDomainModel: Equatable {
    static let empty: Self = .init(name: "", sugar: "", foodCode: "")
    var name: String
    var sugar: String
    var foodCode: String
    var favorite: Bool = false
    
    init(name: String,
         sugar: String,
         foodCode: String) {
        self.name = name
        self.sugar = sugar
        self.foodCode = foodCode
    }
        
    init(_ foodInfoFromAPI: foodInfo) {
        self.name = foodInfoFromAPI.nameContent ?? ""
        self.sugar = foodInfoFromAPI.sugarContent ?? ""
        self.foodCode = foodInfoFromAPI.foodCode ?? ""
    }
}
