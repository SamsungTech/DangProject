//
//  SettingUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation

import RxSwift
import RxRelay

class SettingUseCase {
    private var repository: SettingRepository?
    
    var alarmArray: [AlarmEntity] = [
        AlarmEntity(isOn: false,
                    title: "아침식사",
                    time: .makeTime(hour: 8, minute: 0),
                    selectedDays: "매일"),
        AlarmEntity(isOn: true,
                    title: "아침식사",
                    time: .makeTime(hour: 9, minute: 0),
                    selectedDays: "주말"),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    time: .makeTime(hour: 11, minute: 0),
                    selectedDays: "주중"),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    time: .makeTime(hour: 12, minute: 0),
                    selectedDays: "화"),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    time: .makeTime(hour: 13, minute: 0),
                    selectedDays: "매일"),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    time: .makeTime(hour: 16, minute: 0),
                    selectedDays: "매일")
    ]
    
    var alarmArrayRelay = BehaviorRelay<[AlarmEntity]>(value: [])
    
    init(repository: SettingRepository) {
        self.repository = repository
        startAlarmData()
    }
    
    func startAlarmData() {
        alarmArrayRelay.accept(alarmArray)
    }
    
    func removeAlarmData(_ indexPath: IndexPath) {
        
        alarmArray.remove(at: indexPath.row)
        // MARK: 다시 데이터 넣기
        
        
        alarmArrayRelay.accept(alarmArray)
        
    }
    
    func insertAlarmData(_ indexPath: IndexPath,
                         _ alarmEntity: AlarmEntity) {
        alarmArray.insert(alarmEntity, at: indexPath.row)
        alarmArrayRelay.accept(alarmArray)
    }
}
