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
    var message: String
    var time: Date
    var amPm: String
    var timeText: String
    var selectedDaysOfWeek: [Int]
    var selectedDays: String
    var isEveryDay: Bool
    
    init(alarmEntity: AlarmEntity) {
        self.isOn = alarmEntity.isOn
        self.title = alarmEntity.title
        self.message = alarmEntity.message
        self.time = alarmEntity.time
        self.amPm = .timeToAmPm(alarmEntity.time)
        self.timeText = .timeToString(alarmEntity.time)
        self.selectedDaysOfWeek = alarmEntity.selectedDaysOfTheWeek
        self.selectedDays = Self.calculateSelectedDays(alarmEntity.selectedDaysOfTheWeek)
        self.isEveryDay = Self.calculateEveryDay(alarmEntity.selectedDaysOfTheWeek)
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
            return [0,1,2,3,4,5,6]
        } else {
            return []
        }
    }
    
    static func calculateEveryDay(_ days: [Int]) -> Bool {
        if days == [0,1,2,3,4,5,6] {
            return true
        } else {
            return false
        }
    }
    
    static func calculateSelectedDays(_ days: [Int]) -> String {
        // 0: 일요일, 1: 월요일, 2: 화요일, 3: 수요일, 4: 목요일, 5: 금요일, 6: 토요일
        let days = days.sorted()
        if days == [0,1,2,3,4,5,6] {
            return "매일"
        } else if days == [] {
            return "요일을 선택해 주세요"
        } else if days == [0,6] {
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
