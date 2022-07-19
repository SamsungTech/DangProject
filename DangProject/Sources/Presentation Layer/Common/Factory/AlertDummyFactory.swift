//
//  AlertFactory.swift
//  DangProject
//
//  Created by 김동우 on 2022/05/13.
//

import Foundation

enum AlertTime {
    case morning
    case lunch
    case evening
    case snack
}

class AlertDummyFactory {
    func createDummyAlertData(_ alertTime: AlertTime) -> AlarmEntity {
        switch alertTime {
        case .morning:
            return AlarmEntity(
                isOn: true,
                title: "아침 식사",
                time: .makeTime(hour: 10, minute: 0),
                selectedDays: "매일"
            )
        case .lunch:
            return AlarmEntity(
                isOn: true,
                title: "점심 식사",
                time: .makeTime(hour: 12, minute: 0),
                selectedDays: "매일"
            )
        case .evening:
            return AlarmEntity(
                isOn: true,
                title: "저녁 식사",
                time: .makeTime(hour: 18, minute: 0),
                selectedDays: "매일"
            )
        case .snack:
            return AlarmEntity(
                isOn: true,
                title: "간식",
                time: .makeTime(hour: 0, minute: 0),
                selectedDays: "매일"
            )
        }
    }
}
