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
    let foodModels: [FoodViewModel]?
    
    init(keyWord: String, foodModels: [FoodViewModel]) {
        self.keyWord = keyWord
        self.foodModels = foodModels
    }
}

struct FoodViewModel {
    let name: String?
    let sugar: String?
    let code: String?
    let image: UIImage?
    
    init(_ foodDomainModel: FoodDomainModel) {
        self.name = foodDomainModel.name
        self.sugar = foodDomainModel.sugar
        self.code = foodDomainModel.foodCode
        
        if foodDomainModel.favorite == true {
            self.image = UIImage(systemName: "star.fill")
        } else {
            self.image = UIImage(systemName: "star")
        }
    }
}
