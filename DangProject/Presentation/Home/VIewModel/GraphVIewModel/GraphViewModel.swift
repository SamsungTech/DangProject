//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

struct weekTemp {
    static let empty: Self = .init(tempNutrient: .empty)
    
    var dangdang: Double = 0.0
    
    init(tempNutrient: tempNutrient) {
        guard let dangdang = tempNutrient.dang else { return }
        guard let dangdang = Double(dangdang) else { return }
        self.dangdang = dangdang
    }
}

class GraphViewModel {
    var items = BehaviorRelay<[weekTemp]>(value: [])
    
    init(item: [weekTemp]) {
        self.items.accept(item)
    }
}
