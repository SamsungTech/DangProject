//
//  BatteryCellViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/16.
//

import Foundation
import RxRelay

class BatteryCellViewModel {
    // MARK: sugarSum은 Domain 레이어에 entity인데 viewModel에서 사용가능?
    var items = BehaviorRelay<sugarSum>(value: .empty)
    
    init(item: sugarSum) {
        self.items.accept(item)
    }
}
