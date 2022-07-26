//
//  SettingUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/22.
//

import Foundation
import UserNotifications

import RxSwift

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
    private var tempAlarmData: [AlarmDomainModel] = [
        AlarmDomainModel(isOn: false,
                    title: "아침식사",
                    message: "아침먹고 기록",
                    time: .makeTime(hour: 8, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5,6,7]),
        AlarmDomainModel(isOn: false,
                    title: "아침식사",
                    message: "",
                    time: .makeTime(hour: 9, minute: 0),
                    selectedDaysOfTheWeek: [6,7]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "점심먹었다",
                    time: .makeTime(hour: 11, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,4,5]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 12, minute: 0),
                    selectedDaysOfTheWeek: [2,3,4,5,6]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 13, minute: 0),
                    selectedDaysOfTheWeek: [3,4,7]),
        AlarmDomainModel(isOn: false,
                    title: "점심식사",
                    message: "",
                    time: .makeTime(hour: 16, minute: 0),
                    selectedDaysOfTheWeek: [1,2,3,7]),
    ]
    
    var alarmDomainModelsRelay = BehaviorSubject<[AlarmDomainModel]>(value: [])
    
    // MARK: - Init
    private var coreDataManagerRepository: CoreDataManagerRepository
    init(coreDataManagerRepository: CoreDataManagerRepository) {
        self.coreDataManagerRepository = coreDataManagerRepository
        fetchAlarmFromCoreData()
    }
    
    private func fetchAlarmFromCoreData() {
        guard UserDefaults.standard.bool(forKey: UserInfoKey.initialAlarmDataIsNeeded) else {
            return makeInitialAlarmData()
        }
            alarmDomainModelsRelay.onNext(coreDataManagerRepository.readTotalAlarmEntity())
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
        let alarmEntity: AlarmDomainModel = .init(alarmTableViewCellViewModel: data)
        switch changedOption {
        case .add:
            createNotificationRequest(alarmEntity)
            coreDataManagerRepository.createAlarmEntity(alarmEntity)
        case .delete:
            if data.isOn {
                deleteNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.deleteAlarmEntity(alarmEntity)
        case .isOn:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            } else {
                deleteNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmEntity)
        case .message:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmEntity)
        case .time:
            if data.isOn {
                createNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmEntity)
        case .isEveryDay:
            if data.isEveryDay {
                if data.isOn{
                    createNotificationRequest(alarmEntity)
                }
            } else {
                deleteNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmEntity)
        case .dayOfWeek:
            if data.isOn {
                updateNotificationRequest(alarmEntity)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmEntity)
        }
    }
    
    // MARK: - Private
    private func makeNotificationContent(_ data: AlarmDomainModel) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = data.title
        content.subtitle = "🍽 먹은것을 입력해 주세요!"
        content.body = data.message
        return content
    }
    
    private func makeNotificationTrigger(_ data: AlarmDomainModel, weekday: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: data.time)
        dateComponents.weekday = weekday
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    private func createNotificationRequest(_ data: AlarmDomainModel) {
        let content = makeNotificationContent(data)
        
        data.selectedDaysOfTheWeek.forEach { weekday in
            let identifier = AlarmDomainModel.makeAlarmIdentifier(origin: data.identifier, weekday: weekday)
            let trigger = makeNotificationTrigger(data, weekday: weekday)
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func updateNotificationRequest(_ data: AlarmDomainModel) {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            for i in 1...7 {
                let identifier = AlarmDomainModel.makeAlarmIdentifier(origin: data.identifier,
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
    
    private func deleteNotificationRequest(_ data: AlarmDomainModel) {
        var removeIdentifiers: [String] = []
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            for i in 1...7 {
                let identifier = AlarmDomainModel.makeAlarmIdentifier(origin: data.identifier,
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
    
    private func makeInitialAlarmData(){
        AlarmDomainModel.initialAlarmDomainModel.forEach { alarmModel in
            coreDataManagerRepository.createAlarmEntity(alarmModel)
        }
        alarmDomainModelsRelay.onNext(coreDataManagerRepository.readTotalAlarmEntity())
        UserDefaults.standard.set(true, forKey: UserInfoKey.initialAlarmDataIsNeeded)
    }
}
