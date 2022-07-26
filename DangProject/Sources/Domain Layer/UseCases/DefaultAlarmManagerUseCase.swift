//
//  SettingUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation
import UserNotifications

import RxSwift
import RxRelay

enum ChangeableAlarmOption {
    case add
    case delete
    case isOn
    case message
    case time
    case isEveryDay
    case dayOfWeek
}

class DefaultAlarmManagerUseCase: AlarmManagerUseCase {
    private var repository: SettingRepository?
    
    private var tempAlarmData: [AlarmEntity] = [
        AlarmEntity(isOn: false,
                    title: "아침식사",
                    message: "아침먹고 기록",
                    time: .makeTime(hour: 8, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5,6,7]),
        AlarmEntity(isOn: false,
                    title: "아침식사",
                    message: "",
                    time: .makeTime(hour: 9, minute: 0),
                    selectedDaysOfTheWeek: [6,7]),
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
                    selectedDaysOfTheWeek: [3,4,7]),
        AlarmEntity(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 16, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,7]),
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
    func getRequestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { didAllow, error in
            if didAllow {
                UserDefaults.standard.set(true, forKey: UserInfoKey.userNotificationsPermission)
            } else {
                print("UserNotifications Permission Denied")
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func changeAlarmNotificationRequest(data: AlarmTableViewCellViewModel,
                                        changedOption: ChangeableAlarmOption) {
        let alarmEntity: AlarmEntity = .init(alarmTableViewCellViewModel: data)
        switch changedOption {
        case .add:
            createNotificationRequest(alarmEntity)
        case .delete:
            if data.isOn {
                deleteNotificationRequest(alarmEntity)
            }
        case .isOn:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            } else {
                deleteNotificationRequest(alarmEntity)
            }
        case .message:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            }
        case .time:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            }
        case .isEveryDay:
            if data.isEveryDay {
                if data.isOn{
                    createNotificationRequest(alarmEntity)
                }
            } else {
                deleteNotificationRequest(alarmEntity)
            }
        case .dayOfWeek:
            if data.isOn {
                updateNotificationRequest(alarmEntity)
            }
        }
    }
    
    // MARK: - Private
    private func makeNotificationContent(_ data: AlarmEntity) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.subtitle = "🍽 먹은것을 입력해 주세요!"
        content.body = data.message
        return content
    }
    
    private func makeNotificationTrigger(_ data: AlarmEntity, weekday: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: data.time)
        dateComponents.weekday = weekday
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    private func createNotificationRequest(_ data: AlarmEntity) {
        let content = makeNotificationContent(data)
        
        data.selectedDaysOfTheWeek.forEach { weekday in
            let identifier = AlarmEntity.makeAlarmIdentifier(origin: data.identifier, weekday: weekday)
            let trigger = makeNotificationTrigger(data, weekday: weekday)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func updateNotificationRequest(_ data: AlarmEntity) {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            for i in 1...7 {
                let identifier = AlarmEntity.makeAlarmIdentifier(origin: data.identifier,
                                                                 weekday: i)
                notificationRequests.forEach { requests in
                    if identifier == requests.identifier {
                        removeIdentifiers.append(identifier)
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
            self.createNotificationRequest(data)
        }
    }
    
    private func deleteNotificationRequest(_ data: AlarmEntity) {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            for i in 1...7 {
                let identifier = AlarmEntity.makeAlarmIdentifier(origin: data.identifier,
                                                                 weekday: i)
                notificationRequests.forEach { requests in
                    if identifier == requests.identifier {
                        removeIdentifiers.append(identifier)
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
    }
}
