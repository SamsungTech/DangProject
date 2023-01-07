//
//  EatenFoodForDelete.swift
//  DangProject
//
//  Created by 김동우 on 2023/01/07.
//

import Foundation

struct EatenFoodForDelete {
    static let empty: Self = .init(year: "",
                                   month: "",
                                   day: "",
                                   foodName: "")
    
    var year: String
    var month: String
    var day: String
    var foodName: String
    
    init(year: String,
         month: String,
         day: String,
         foodName: String) {
        self.year = year
        self.month = month
        self.day = day
        self.foodName = foodName
    }
}
