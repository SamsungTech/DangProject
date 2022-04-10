//
//  AteFoodItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

struct AteFoodData {
    static let empty: Self = .init(dangArray: [],
                                   foodNameArray: [])
    var dangArray: [String]
    var foodNameArray: [String]
    
    init(dangArray: [String],
         foodNameArray: [String]) {
        self.dangArray = dangArray
        self.foodNameArray = foodNameArray
    }
}

class AteFoodViewModel {
    var items = BehaviorRelay<AteFoodData>(value: .empty)
    
    init(item: AteFoodData) {
        self.items.accept(item)
    }
    
    init(viewModel: HomeViewModel) {
        guard let monthDang = viewModel.dangComprehensiveData.value.tempDang,
              let tempFoodName = viewModel.dangComprehensiveData.value.tempFoodName else { return }
        
        self.items.accept(
            AteFoodData(dangArray: monthDang,
                        foodNameArray: tempFoodName)
        )
    }
}
