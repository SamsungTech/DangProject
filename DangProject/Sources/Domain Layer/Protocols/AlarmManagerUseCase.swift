//
//  AlarmManagerUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/07/25.
//

import Foundation

import RxSwift

protocol AlarmManagerUseCase {
    var alarmDomainModelsRelay: BehaviorSubject<[AlarmDomainModel]> { get }
    func getRequestAuthorization()
    func changeAlarmNotificationRequest(data: AlarmTableViewCellViewModel,
                                        changedOption: ChangeableAlarmOption)
}
