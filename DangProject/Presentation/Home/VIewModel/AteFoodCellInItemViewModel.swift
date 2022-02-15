//
//  AteFoodCellInItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

class AteFoodCellInItemViewModel {
    var items = BehaviorRelay<tempNutrient>(value: .init())
    
    init(item: tempNutrient) {
        self.items.accept(item)
    }
}
