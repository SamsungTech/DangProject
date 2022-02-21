//
//  DetailFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation
import UIKit

protocol DetailFoodViewModelInput {
    func changeDetailFoodFavorite()
}

protocol DetailFoodViewModelOutput {
    func setSugarArrowAngle(amount: Double) -> Double
}

protocol DetailFoodViewModelProtocol: DetailFoodViewModelInput, DetailFoodViewModelOutput {}

class DetailFoodViewModel: DetailFoodViewModelProtocol {
    
    // MARK: - Init
    var addFoodsUseCase: AddFoodsUseCase
    var detailFood: FoodViewModel
    init(detailFood: FoodViewModel, addFoodsUseCase: AddFoodsUseCase) {
        self.detailFood = detailFood
        self.addFoodsUseCase = addFoodsUseCase
//        setSugarArrowAngle(amount: 1)
    }
    // MARK: - Input
    
    func changeDetailFoodFavorite() {
        detailFood.image = detailFood.image == UIImage(systemName: "star") ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    func addFoods(foods: AddFoodsViewModel) {
        addFoodsUseCase.addEatenFoods(food: FoodDomainModel.init(foods))
    }
    // MARK: - Output
    
    func setSugarArrowAngle(amount: Double) -> Double {
        guard let sugar = detailFood.sugar else { return 0 }
        guard let sugarDouble = Double(sugar) else { return 0 }
        if sugarDouble * amount > 30 {
            return 180
        } else {
            return sugarDouble * amount * 6
        }
    }    
}
