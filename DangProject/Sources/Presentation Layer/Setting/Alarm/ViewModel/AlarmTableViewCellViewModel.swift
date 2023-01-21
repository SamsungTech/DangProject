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
    case none
}

enum CellReuseState {
    case reuse
    case none
}

struct AlarmTableViewCellViewModel: Equatable {
    static let empty: Self = .init(alarmDomainModel: .empty)
    var scale: CellScaleState = .normal
    var isOn: Bool
    var title: String
    var message: String
    var time: Date
    var amPm: String
    var timeText: String
    var selectedDaysOfWeek: [DayOfWeek]
    var selectedDays: String
    var isEveryDay: Bool
    var identifier: String
    
    init(alarmDomainModel: AlarmDomainModel) {
        self.isOn = alarmDomainModel.isOn
        self.title = alarmDomainModel.title
        self.message = alarmDomainModel.message
        self.time = alarmDomainModel.time
        self.amPm = .timeToAmPm(alarmDomainModel.time)
        self.timeText = .timeToString(alarmDomainModel.time)
        self.selectedDaysOfWeek = alarmDomainModel.selectedDaysOfTheWeek
        self.selectedDays = Self.calculateSelectedDays(alarmDomainModel.selectedDaysOfTheWeek)
        self.isEveryDay = Self.calculateEveryDay(alarmDomainModel.selectedDaysOfTheWeek)
        self.identifier = alarmDomainModel.identifier
        }
    
    static func calculateIsOn(days: [DayOfWeek], origin: Bool) -> Bool {
        if days.count == 0 {
            return false
        } else {
            return origin
        }
    }
    
    static func calculateDaysOfWeek(_ isEveryDay: Bool) -> [DayOfWeek] {
        if isEveryDay {
            return [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
        } else {
            return []
        }
    }
    
    static func calculateEveryDay(_ days: [DayOfWeek]) -> Bool {
        if days == [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] {
            return true
        } else {
            return false
        }
    }
    
    static func calculateSelectedDays(_ days: [DayOfWeek]) -> String {
        if days == [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] {
            return "매일"
        } else if days == [] {
            return "요일을 선택해 주세요"
        } else if days == [.saturday, .sunday] {
            return "주말"
        } else if days == [.monday, .tuesday, .wednesday, .thursday, .friday] {
            return "주중"
        } else {
            return self.daysToString(days)
        }
    }
   
    static func daysToString(_ days: [DayOfWeek]) -> String {
        var result = ""
        for i in 0 ..< days.count {
            let convertString: String = Self.dayOfWeekToString(days[i])
            if i == 0 {
                result = convertString
            } else {
                result = result + ", " + convertString
            }
        }
        return result
    }
    
    static func dayOfWeekToString(_ dayOfWeek: DayOfWeek) -> String {
        switch dayOfWeek {
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        case .sunday:
            return "일"
        }
    }

}
