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
    var identifier: String
    
    init(isOn: Bool, title: String, message: String, time: Date, selectedDaysOfTheWeek: [Int]) {
        self.isOn = isOn
        self.title = title
        self.message = message
        self.time = time
        self.selectedDaysOfTheWeek = selectedDaysOfTheWeek
        self.identifier = Self.makeDefaultAlarmIdentifier(title: title, time: time)
    }
    
    init(alarmTableViewCellViewModel: AlarmTableViewCellViewModel) {
        self.isOn = alarmTableViewCellViewModel.isOn
        self.title = alarmTableViewCellViewModel.title
        self.message = alarmTableViewCellViewModel.message
        self.time = .stringToDate(amPm: alarmTableViewCellViewModel.amPm,
                                  time: alarmTableViewCellViewModel.timeText)
        self.selectedDaysOfTheWeek = alarmTableViewCellViewModel.selectedDaysOfWeek
        self.identifier = alarmTableViewCellViewModel.identifier
    }
    
    static func makeDefaultAlarmIdentifier(title: String, time: Date) -> String {
        let alarmInformation = "\(title) \(String.timeToStringWith24Hour(time))"
        let currentTimeString: String = .currentDateToString()
        return "\(alarmInformation) \(currentTimeString)"
    }
    
    static func makeAlarmIdentifier(origin: String, weekday: Int) -> String {
        return "\(origin) \(String(weekday))"
    }
    
}
