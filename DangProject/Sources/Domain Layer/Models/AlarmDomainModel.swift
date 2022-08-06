//
//  AlarmEntity.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/05.
//

import Foundation

enum DayOfWeek: Int {
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
    case sunday = 7
}

struct AlarmDomainModel {
    static let empty: Self = .init(isOn: Bool(),
                                   title: "",
                                   time: Date.init(),
                                   selectedDaysOfTheWeek: [])
    var isOn: Bool
    var title: String
    var message: String = ""
    var time: Date
    var selectedDaysOfTheWeek: [DayOfWeek]
    var identifier: String
    
    init(isOn: Bool, title: String, time: Date, selectedDaysOfTheWeek: [DayOfWeek]) {
        self.isOn = isOn
        self.title = title
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
        self.selectedDaysOfTheWeek = alarmEntity.selectedDays.map{ DayOfWeek(rawValue: $0)! }
        self.identifier = alarmEntity.identifier
    }
    
    static func makeDefaultAlarmIdentifier(title: String, time: Date) -> String {
        let alarmInformation = "\(title) \(String.timeToStringWith24Hour(time))"
        let currentTimeString: String = .currentDateToString()
        return "\(alarmInformation) \(currentTimeString)"
    }
    
    static func makeAlarmIdentifier(origin: String, weekday: Int) -> String {
        return "\(origin) \(String(weekday))"
    }
    
    static func makeInitialAlarmData() -> [Self] {
        return [
            AlarmDomainModel(isOn: false,
                             title: "아침식사",
                             time: .makeTime(hour: 9, minute: 0),
                             selectedDaysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday]),
            AlarmDomainModel(isOn: false,
                             title: "점심식사",
                             time: .makeTime(hour: 12, minute: 0),
                             selectedDaysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]),
            AlarmDomainModel(isOn: false,
                             title: "간식",
                             time: .makeTime(hour: 14, minute: 0),
                             selectedDaysOfTheWeek: [.monday, .wednesday, .friday]),
            AlarmDomainModel(isOn: false,
                             title: "저녁식사",
                             time: .makeTime(hour: 18, minute: 0),
                             selectedDaysOfTheWeek: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])
        ]
    }
    
}
