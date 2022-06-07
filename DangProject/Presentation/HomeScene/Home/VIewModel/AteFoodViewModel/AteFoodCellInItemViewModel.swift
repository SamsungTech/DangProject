//
//  AteFoodCellInItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay

struct AteFoodCellEntity {
    static let empty: Self = .init(dang: "", foodName: "")
    var dang: String?
    var foodName: String?
    
    init(dang: String,
         foodName: String) {
        self.dang = dang
        self.foodName = foodName
    }
}

class AteFoodCellInItemViewModel {
    var items = BehaviorRelay<AteFoodCellEntity>(value: .empty)
    
    init(item: AteFoodCellEntity) {
        self.items.accept(item)
    }
}
