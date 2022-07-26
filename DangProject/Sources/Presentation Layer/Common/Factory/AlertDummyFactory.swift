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
    func createDummyAlertData(_ alertTime: AlertTime) -> AlarmDomainModel {
        switch alertTime {
        case .morning:
            return AlarmDomainModel(
                isOn: true,
                title: "아침 식사",
                message: "",
                time: .makeTime(hour: 10, minute: 0),
                selectedDaysOfTheWeek: [0,1,2,3,4,5,6]
            )
        case .lunch:
            return AlarmDomainModel(
                isOn: true,
                title: "점심 식사",
                message: "",
                time: .makeTime(hour: 12, minute: 0),
                selectedDaysOfTheWeek: [0,6]
            )
        case .evening:
            return AlarmDomainModel(
                isOn: true,
                title: "저녁 식사",
                message: "",
                time: .makeTime(hour: 18, minute: 0),
                selectedDaysOfTheWeek: [1,2,3,4,5]
            )
        case .snack:
            return AlarmDomainModel(
                isOn: true,
                title: "간식",
                message: "",
                time: .makeTime(hour: 0, minute: 0),
                selectedDaysOfTheWeek: [2,3,4,5,6]
            )
        }
    }
}
