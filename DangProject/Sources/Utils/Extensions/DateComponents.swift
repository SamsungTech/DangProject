//
//  DateComponents.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/09.
//

import Foundation

extension DateComponents {
    static func currentDateTimeComponents() -> DateComponents {
        let currentDateTime = Date()
        let userCalendar = Calendar.current
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        return userCalendar.dateComponents(requestedComponents, from: currentDateTime)
    }
}
