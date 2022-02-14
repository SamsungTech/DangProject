//
//  SearchFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/08.
//

import Foundation
import UIKit

struct SearchFoodViewModel {
    static let empty: Self = .init(keyWord: "", foodModels: [])
    let keyWord: String?
    let foodModels: [FoodDomainModel]?
    
    init(keyWord: String, foodModels: [FoodDomainModel]) {
        self.keyWord = keyWord
        self.foodModels = foodModels
    }
}
