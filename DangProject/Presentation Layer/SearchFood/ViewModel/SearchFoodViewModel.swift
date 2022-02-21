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
struct AddFoodsViewModel {
    var amount = 1
    let foodModel: FoodViewModel?
    
    init(amount: Int, foodModel: FoodViewModel) {
        self.amount = amount
        self.foodModel = foodModel
    }
}

struct FoodViewModel {
    static let empty: Self = .init(name: "", sugar: "", code: "", image: UIImage())
    let name: String?
    let sugar: String?
    let code: String?
    var image: UIImage?
//    var amount = 1
    
    init (name: String, sugar: String, code: String, image: UIImage) {
        self.name = name
        self.sugar = sugar
        self.code = code
        self.image = image
    }
    
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
