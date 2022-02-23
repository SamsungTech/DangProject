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
        // MARK: 여기서 형변환 ㄴㄴ
        guard let dangdang = Double(dangdang) else { return }
        self.dangdang = dangdang
    }
}

class GraphItemViewModel {
    var items = BehaviorRelay<[weekTemp]>(value: [])
    
    init(item: [weekTemp]) {
        self.items.accept(item)
    }
}
