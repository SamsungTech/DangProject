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

struct AlarmTableViewCellViewModel: Equatable {
    static let empty: Self = .init(alarmDomainModel: .empty)
    var scale: CellScaleState = .normal
    var isOn: Bool
    var title: String
    var message: String
    var time: Date
    var amPm: String
    var timeText: String
    var selectedDaysOfWeek: [Int]
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
    
    static func calculateIsOn(days: [Int], origin: Bool) -> Bool {
        if days.count == 0 {
            return false
        } else {
            return origin
        }
    }
    
    static func calculateDaysOfWeek(_ isEveryDay: Bool) -> [Int] {
        if isEveryDay {
            return [1,2,3,4,5,6,7]
        } else {
            return []
        }
    }
    
    static func calculateEveryDay(_ days: [Int]) -> Bool {
        if days == [1,2,3,4,5,6,7] {
            return true
        } else {
            return false
        }
    }
    
    static func calculateSelectedDays(_ days: [Int]) -> String {
        // 1: 월요일, 2: 화요일, 3: 수요일, 4: 목요일, 5: 금요일, 6: 토요일, 7: 일요일
        let days = days.sorted()
        if days == [1,2,3,4,5,6,7] {
            return "매일"
        } else if days == [] {
            return "요일을 선택해 주세요"
        } else if days == [6,7] {
            return "주말"
        } else if days == [1,2,3,4,5] {
            return "주중"
        } else {
            return self.daysToString(days)
        }
    }
   
    static func daysToString(_ days: [Int]) -> String {
        var result = ""
        for i in 0 ..< days.count {
            let convertString: String = .configureWeekOfTheDay(days[i])
            if i == 0 {
                result = convertString
            } else {
                result = result + ", " + convertString
            }
        }
        return result
    }
}
