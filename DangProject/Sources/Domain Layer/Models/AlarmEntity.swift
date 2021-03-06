//
//  AlarmEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/05.
//

import Foundation

struct AlarmEntity {
    static let empty: Self = .init(isOn: Bool(),
                                   title: "",
                                   time: "",
                                   selectedDays: "")
    var isOn: Bool
    var title: String
    var time: String
    var selectedDays: String
}
