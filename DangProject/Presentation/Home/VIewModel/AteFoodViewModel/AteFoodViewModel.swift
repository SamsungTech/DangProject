//
//  AteFoodItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

class AteFoodViewModel: ViewModelFactoryProtocol {
    var items = BehaviorRelay<[tempNutrient]>(value: [])
    
    init(item: [tempNutrient]) {
        self.items.accept(item)
    }
    
    init(viewModel: HomeViewModel) {
        self.items.accept(viewModel.tempData.value)
    }
}
