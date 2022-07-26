//
//  AlarmEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/05.
//

import Foundation

struct AlarmDomainModel {
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
    
    init(alarmEntity: Alarm) {
        self.isOn = alarmEntity.isOn
        self.title = alarmEntity.title
        self.message = alarmEntity.message
        self.time = alarmEntity.time
        self.selectedDaysOfTheWeek = alarmEntity.selectedDays
        self.identifier = alarmEntity.identifier
    }
    
    static let initialAlarmDomainModel: [Self] = [
        AlarmDomainModel(isOn: false,
                    title: "아침식사",
                    message: "아침먹고 기록",
                    time: .makeTime(hour: 8, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5,6,7]),
        AlarmDomainModel(isOn: false,
                    title: "아침식사",
                    message: "",
                    time: .makeTime(hour: 9, minute: 0),
                    selectedDaysOfTheWeek: [6,7]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "점심먹었다",
                    time: .makeTime(hour: 11, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 12, minute: 0),
                    selectedDaysOfTheWeek: [2,3,4,5,6]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 13, minute: 0),
                    selectedDaysOfTheWeek: [3,4,7]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 16, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,7]),
    ]
    
    static func makeDefaultAlarmIdentifier(title: String, time: Date) -> String {
        let alarmInformation = "\(title) \(String.timeToStringWith24Hour(time))"
        let currentTimeString: String = .currentDateToString()
        return "\(alarmInformation) \(currentTimeString)"
    }
    
    static func makeAlarmIdentifier(origin: String, weekday: Int) -> String {
        return "\(origin) \(String(weekday))"
    }
    
}
