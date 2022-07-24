//
//  SettingUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation

import RxSwift
import RxRelay

enum ChangeableAlarmOption {
    case add
    case delete
    case isOn
    case message
    case time
    case dayOfWeek
}

class DefaultAlarmManagerUseCase {
    private var repository: SettingRepository?
    
    private var tempAlarmData: [AlarmEntity] = [
        AlarmEntity(isOn: false,
                    title: "아침식사",
                    message: "아침먹고 기록",
                    time: .makeTime(hour: 8, minute: 0),
                    selectedDaysOfTheWeek: [0,1,2,3,4,5,6]),
        AlarmEntity(isOn: true,
                    title: "아침식사",
                    message: "",
                    time: .makeTime(hour: 9, minute: 0),
                    selectedDaysOfTheWeek: [0,6]),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    message: "점심먹었다",
                    time: .makeTime(hour: 11, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5]),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 12, minute: 0),
                    selectedDaysOfTheWeek: [2,3,4,5,6]),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 13, minute: 0),
                    selectedDaysOfTheWeek: [0,3,4]),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 16, minute: 0),
                    selectedDaysOfTheWeek: [0,1,2,3]),
    ]

    var alarmArrayRelay = BehaviorRelay<[AlarmEntity]>(value: [])
    
    // MARK: - Init
    init(repository: SettingRepository) {
        self.repository = repository
        startAlarmData()
    }
    
    private func startAlarmData() {
        alarmArrayRelay.accept(tempAlarmData)
    }
    
    // MARK: - Internal
    func alarmDataChanged(data: AlarmEntity, changedOption: ChangeableAlarmOption) {
//        var alarmEntity: AlarmEntity = .init(alarmTableViewCellViewModel: data)
//        switch changedOption {
//        case .add:
//            <#code#>
//        case .delete:
//            <#code#>
//        case .isOn:
//            <#code#>
//        case .message:
//            <#code#>
//        case .time:
//            <#code#>
//        case .dayOfWeek:
//            <#code#>
//        }
    }
    
    // MARK: - Private
    
    func removeAlarmData(_ indexPath: Int) {
        
        tempAlarmData.remove(at: indexPath)
        // MARK: 다시 데이터 넣기
        alarmArrayRelay.accept(tempAlarmData)
        
    }
    
    func insertAlarmData(_ indexPath: IndexPath,
                         _ alarmEntity: AlarmEntity) {
        tempAlarmData.insert(alarmEntity, at: indexPath.row)
        alarmArrayRelay.accept(tempAlarmData)
    }
}
