//
//  CheckCurrentTimeUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/04.
//

import Foundation

class CheckCurrentTimeUseCase {

    private let currentDateTime = Date()
    private let userCalendar = Calendar.current
    private let requestedComponents: Set<Calendar.Component> = [
        .year,
        .month,
        .day,
        .hour,
        .minute,
        .second
    ]

    lazy var dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

}
