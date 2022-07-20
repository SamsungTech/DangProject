//
//  AlarmTableViewItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/27.
//

import UIKit

enum CellScaleState {
    case expand
    case normal
    case moreExpand
}

struct AlarmTableViewCellViewModel {
    static let empty: Self = .init(alarmEntity: .empty)
    var scale: CellScaleState = .normal
    var isOn: Bool
    var title: String
    var pmAm: String
    var time: String
    var selectedDays: String
    
    init(alarmEntity: AlarmEntity) {
        self.isOn = alarmEntity.isOn
        self.title = alarmEntity.title
        self.pmAm = .calculateAmPm(alarmEntity.time)
        self.time = .timeToString(alarmEntity.time)
        self.selectedDays = alarmEntity.selectedDays
    }
}
