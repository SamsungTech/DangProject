//
//  DetailFoodViewModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/16.
//

import Foundation
import UIKit

import RxSwift
import RxCocoa

protocol DetailFoodViewModelInput {
    var amount: Int { get }
    var pickerViewIsActivatedObservable: BehaviorRelay<Bool> { get }
    var pickerViewIsActivated: Bool { get }
    func changeDetailFoodFavorite()
    func addFoods(foods: AddFoodsViewModel, completion: @escaping (Bool) -> Void)
    func changePickerViewWillActivated()
    func amountChanged(amount: Int)
}

protocol DetailFoodViewModelOutput {
    var pickerList: [String] { get }
    func setSugarArrowAngle(amount: Double) -> CGFloat
    func numberOfComponents() -> Int
    func getTotalSugar() -> Double
    func branchOutCircleState(amount: Double) -> CustomProgressBarStateColor
    func branchOutPickerViewInActivated() -> Bool
}

protocol DetailFoodViewModelProtocol: DetailFoodViewModelInput, DetailFoodViewModelOutput {}

class DetailFoodViewModel: DetailFoodViewModelProtocol {
    // MARK: - Init
    var detailFood: FoodViewModel
    private let addFoodsUseCase: AddFoodsUseCase
    private var isFirstActivated = true
    init(detailFood: FoodViewModel,
         addFoodsUseCase: AddFoodsUseCase) {
        self.detailFood = detailFood
        self.addFoodsUseCase = addFoodsUseCase
    }

    // MARK: - Input
    var amount: Int = 1
    var pickerViewIsActivatedObservable = BehaviorRelay(value: false)
    var pickerViewIsActivated = false
    lazy var detailFoodObservable = BehaviorRelay(value: detailFood)
    
    func changeDetailFoodFavorite() {
        let willChangeImage = detailFood.image == UIImage(systemName: "star") ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        detailFood.image = willChangeImage
    }
    
    func addFoods(foods: AddFoodsViewModel, completion: @escaping (Bool) -> Void) {
        addFoodsUseCase.addEatenFoods(food: FoodDomainModel.init(foods), completion: completion)
    }
    
    func changePickerViewWillActivated() {
        pickerViewIsActivated = !pickerViewIsActivated
        pickerViewIsActivatedObservable.accept(pickerViewIsActivated)
    }
    
    func amountChanged(amount: Int) {
        self.amount = amount
        detailFoodObservable.accept(detailFood)
    }
    // MARK: - Output
    
    var pickerList: [String] = [Int](0...10).map{("\($0)")}
    
    func setSugarArrowAngle(amount: Double) -> CGFloat {
        guard let sugar = detailFood.sugar else { return 0 }
        guard let sugarDouble = Double(sugar) else { return 0 }
        if sugarDouble * amount > 30 {
            return 3.141592653589792
        } else {
            return (sugarDouble * amount * 6)*CGFloat.pi / 180
        }
    }
    
    func numberOfComponents() -> Int {
        if pickerViewIsActivated {
            return 2
        } else {
            return 0
        }
    }
    
    func getTotalSugar() -> Double {
        guard let sugar = detailFood.sugar else { return 0 }
        let totalSugar = (Double(sugar) ?? 0) * Double(amount)
        return totalSugar
    }
    
    func branchOutPickerViewInActivated() -> Bool {
        if isFirstActivated {
            isFirstActivated = false
            return false
        } else {
            return true
        }
    }
    
    func branchOutCircleState(amount: Double = 1.0) -> CustomProgressBarStateColor {
        guard let sugar = Double(detailFood.sugar ?? "0") else { return .low }
        
        if sugar*amount > 20 {
            return .high
        } else if sugar*amount > 10 {
            return .middle
        } else {
            return .low
        }
    }
}
