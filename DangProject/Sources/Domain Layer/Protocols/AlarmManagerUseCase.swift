//
//  AlarmManagerUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/25.
//

import Foundation

import RxRelay

protocol AlarmManagerUseCase {
    var alarmArrayRelay: BehaviorRelay<[AlarmDomainModel]> { get }
    func getRequestAuthorization()
    func changeAlarmNotificationRequest(data: AlarmTableViewCellViewModel,
                                        changedOption: ChangeableAlarmOption)
}
