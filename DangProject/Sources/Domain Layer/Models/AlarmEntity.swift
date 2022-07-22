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
                                   message: "",
                                   time: Date.init(),
                                   selectedDaysOfTheWeek: [])
    var isOn: Bool
    var title: String
    var message: String
    var time: Date
    var selectedDaysOfTheWeek: [Int]
    
    init(isOn: Bool, title: String, message: String, time: Date, selectedDaysOfTheWeek: [Int]) {
        self.isOn = isOn
        self.title = title
        self.message = message
        self.time = time
        self.selectedDaysOfTheWeek = selectedDaysOfTheWeek
    }
    
    init(alarmTableViewCellViewModel: AlarmTableViewCellViewModel) {
        self.isOn = alarmTableViewCellViewModel.isOn
        self.title = alarmTableViewCellViewModel.title
        self.message = alarmTableViewCellViewModel.message
        self.time = .stringToDate(amPm: alarmTableViewCellViewModel.amPm,
                                  time: alarmTableViewCellViewModel.time)
        self.selectedDaysOfTheWeek = alarmTableViewCellViewModel.selectedDaysOfWeek
    }
    
}
