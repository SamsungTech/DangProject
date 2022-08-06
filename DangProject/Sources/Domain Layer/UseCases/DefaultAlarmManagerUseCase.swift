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
            if let error = error {
                return print(error.localizedDescription)
            }
            
            if didAllow {
                UserDefaults.standard.set(true, forKey: UserInfoKey.userNotificationsPermission)
            } else {
                print("UserNotifications Permission Denied")
            }
            
        }
    }
    
    func changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel,
                                        changedOption: ChangeableAlarmOption) {

        switch changedOption {
        case .add:
            createNotificationRequest(alarmDomainModel)
            coreDataManagerRepository.createAlarmEntity(alarmDomainModel)
        case .delete:
            if alarmDomainModel.isOn {
                deleteNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.deleteAlarmEntity(alarmDomainModel)
        case .isOn:
            if alarmDomainModel.isOn {
                createNotificationRequest(alarmDomainModel)
            } else {
                deleteNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmDomainModel)
        case .message:
            if alarmDomainModel.isOn {
                createNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmDomainModel)
        case .time:
            if alarmDomainModel.isOn {
                createNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmDomainModel)
        case .isEveryDay:
            if alarmDomainModel.selectedDaysOfTheWeek == [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday] {
                if alarmDomainModel.isOn{
                    createNotificationRequest(alarmDomainModel)
                }
            } else {
                deleteNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmDomainModel)
        case .dayOfWeek:
            if alarmDomainModel.isOn {
                updateNotificationRequest(alarmDomainModel)
            }
            coreDataManagerRepository.updateAlarmEntity(alarmDomainModel)
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
            let identifier = AlarmDomainModel.makeAlarmIdentifier(origin: data.identifier, weekday: weekday.rawValue)
            let trigger = makeNotificationTrigger(data, weekday: weekday.rawValue)
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
        AlarmDomainModel.makeInitialAlarmData().forEach { alarmModel in
            coreDataManagerRepository.createAlarmEntity(alarmModel)
        }
        alarmDomainModelsRelay.onNext(coreDataManagerRepository.readTotalAlarmEntity())
        UserDefaults.standard.set(true, forKey: UserInfoKey.initialAlarmDataIsNeeded)
    }
}
