//
//  TempData.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation

struct tempNutrient {
    static let empty: Self = .init(dang: "", foodName: "")
    
    var dang: String?
    var foodName: String?
}
