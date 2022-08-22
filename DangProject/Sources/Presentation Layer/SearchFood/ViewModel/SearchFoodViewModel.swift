//
//  SearchFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/08.
//

import UIKit

struct AddFoodsViewModel {
    var amount = 1
    let foodModel: FoodViewModel?
    
    init(amount: Int, foodModel: FoodViewModel) {
        self.amount = amount
        self.foodModel = foodModel
    }
}

struct FoodViewModel {
    static let empty: Self = .init(name: "",
                                   sugar: "",
                                   code: "",
                                   image: UIImage(),
                                   targetSugar: 0.0)
    let name: String?
    let sugar: String?
    let code: String?
    var image: UIImage?
    var targetSugar: Double?
    
    init(name: String,
         sugar: String,
         code: String,
         image: UIImage,
         targetSugar: Double) {
        self.name = name
        self.sugar = sugar
        self.code = code
        self.image = image
        self.targetSugar = targetSugar
    }
    
    init(_ foodDomainModel: FoodDomainModel) {
        self.name = foodDomainModel.name
        self.sugar = String(foodDomainModel.sugar)
        self.code = foodDomainModel.foodCode
        self.targetSugar = foodDomainModel.targetSugar
        
        if foodDomainModel.favorite == true {
            self.image = UIImage(systemName: "star.fill")
        } else {
            self.image = UIImage(systemName: "star")
        }
    }
}
