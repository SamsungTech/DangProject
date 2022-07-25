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
    //    case dayOfWeek
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
//        deleteAllRequests()
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
            addNotificationRequest(alarmEntity)
        case .delete:
            deleteNotificationRequest(alarmEntity)
        case .isOn:
            if data.isOn {
                addNotificationRequest(alarmEntity)
            } else {
                deleteNotificationRequest(alarmEntity)
            }
        case .message:
            if data.isOn {
                // update Notification
            }
        case .time:
            if data.isOn {
                // update Notification
            }
        case .isEveryDay:
            // 다시 봐야됨
            if data.isEveryDay {
                // update Notification
            } else {
                deleteNotificationRequest(alarmEntity)
            }
        }
        printAllRequests()
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
    
    private func addNotificationRequest(_ data: AlarmEntity) {
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
    
    private func deleteNotificationRequest(_ data: AlarmEntity) {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            for i in 0 ..< data.selectedDaysOfTheWeek.count {
                let identifier = AlarmEntity.makeAlarmIdentifier(origin: data.identifier,
                                                                 weekday: data.selectedDaysOfTheWeek[i])
                notificationRequests.forEach { requests in
                    if identifier == requests.identifier {
                        removeIdentifiers.append(identifier)
                    }
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
    }
    
    // test
    
    private func deleteAllRequests() {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            notificationRequests.forEach {
                removeIdentifiers.append($0.identifier)
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: removeIdentifiers)
        }
    }
    
    private func printAllRequests() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            notificationRequests.forEach {
                print($0.identifier)
            }
        }
    }
    
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
