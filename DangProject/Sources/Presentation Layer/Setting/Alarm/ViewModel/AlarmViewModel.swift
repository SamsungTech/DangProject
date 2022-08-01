//
//  AlramViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa

enum NavigationBarEvent {
    case back
    case add
}

protocol AlarmViewModelInputProtocol: AnyObject {
    func checkUserNotificationsIsFirst()
    func expandSelectedCell(index: Int)
    func changeCellScale(index: Int)
    func addAlarmDomainModel(_ alarmDomainModel: AlarmDomainModel)
    func changeIsOnValue(index: Int)
    func changeUserMessage(index: Int, text: String)
    func changeTime(index: Int, time: Date)
    func changeDayOfTheWeek(index: Int, tag: Int)
    func changeEveryday(index: Int)
    func willDeleteAlarmData(_ indexPath: Int)
    func deleteAlarmData()
}

protocol AlarmViewModelOutputProtocol: AnyObject {
    var alarmDataArrayRelay: BehaviorRelay<[AlarmTableViewCellViewModel]> { get }
    var cellScaleWillExpand: Bool { get }
    var addedCellIndex: Int { get }
    var changedCellIndex: Int { get }
    var willDeleteCellIndex: Int { get }
    func getHeightForRow(_ indexPath: IndexPath) -> CGFloat
}

protocol AlarmViewModelProtocol: AlarmViewModelInputProtocol, AlarmViewModelOutputProtocol {}

class AlarmViewModel: AlarmViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellViewModel]>(value: [])
    lazy var tempAlarmData: [AlarmTableViewCellViewModel] = { alarmDataArrayRelay.value }()
    lazy var cellScaleWillExpand: Bool = false
    lazy var addedCellIndex: Int = 0
    lazy var changedCellIndex: Int = 0
    lazy var willDeleteCellIndex: Int = 0
    // MARK: - Init
    private var alarmManagerUseCase: AlarmManagerUseCase
    
    init(alarmManagerUseCase: AlarmManagerUseCase) {
        self.alarmManagerUseCase = alarmManagerUseCase
        bindAlarmArraySubject()
    }
    
    private func bindAlarmArraySubject() {
        alarmManagerUseCase.alarmDomainModelsRelay
            .map { $0.map { AlarmTableViewCellViewModel.init(alarmDomainModel: $0) } }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.alarmDataArrayRelay.accept(data)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Input
    func checkUserNotificationsIsFirst() {
        if !UserDefaults.standard.bool(forKey: UserInfoKey.userNotificationsPermission) {
            alarmManagerUseCase.getRequestAuthorization()
        }
    }
    
    func expandSelectedCell(index: Int) {
        resetTotalCellScaleNormal(index: index)
        switch tempAlarmData[index].scale {
        case .normal:
            tempAlarmData[index].scale = .moreExpand
        case .expand:
            tempAlarmData[index].scale = .expand
        case .moreExpand:
            tempAlarmData[index].scale = .moreExpand
        }
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeCellScale(index: Int) {
        resetTotalCellScaleNormal(index: index)
        
        switch tempAlarmData[index].scale {
        case .normal:
            tempAlarmData[index].scale = .moreExpand
            self.cellScaleWillExpand = true
        case .expand:
            tempAlarmData[index].scale = .normal
            self.cellScaleWillExpand = false
        case .moreExpand:
            tempAlarmData[index].scale = .normal
            self.cellScaleWillExpand = false
        }
        
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func addAlarmDomainModel(_ alarmDomainModel: AlarmDomainModel) {
        var alarmViewModel = AlarmTableViewCellViewModel.init(alarmDomainModel: alarmDomainModel)
        alarmViewModel.scale = .moreExpand
        alarmManagerUseCase.changeAlarmNotificationRequest(data: alarmViewModel, changedOption: .add)
        
        tempAlarmData.append(alarmViewModel)
        tempAlarmData = tempAlarmData.sorted { $0.time < $1.time }
        guard let index = self.tempAlarmData.firstIndex(of: alarmViewModel) else { return }
        addedCellIndex = index
        resetTotalCellScaleNormal(index: addedCellIndex)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeIsOnValue(index: Int) {
        tempAlarmData[index].isOn.toggle()
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[index], changedOption: .isOn)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeUserMessage(index: Int, text: String) {
        tempAlarmData[index].message = text
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[index], changedOption: .message)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeTime(index: Int, time: Date) {
        tempAlarmData[index].time = time
        tempAlarmData[index].timeText = .timeToString(time)
        tempAlarmData[index].amPm = .timeToAmPm(time)
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[index], changedOption: .time)
        
        let willChangeAlarmData = tempAlarmData[index]
        tempAlarmData = tempAlarmData.sorted { $0.time < $1.time }
        guard let dataIndex = self.tempAlarmData.firstIndex(of: willChangeAlarmData) else { return }
        changedCellIndex = dataIndex
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeDayOfTheWeek(index: Int, tag: Int) {
        guard let selectedTag = DayOfWeek(rawValue: tag) else { return }
        if tempAlarmData[index].selectedDaysOfWeek.contains(selectedTag) {
            guard let arrayIndex = tempAlarmData[index].selectedDaysOfWeek.firstIndex(of: selectedTag) else { return }
            tempAlarmData[index].selectedDaysOfWeek.remove(at: arrayIndex)
        } else {
            tempAlarmData[index].selectedDaysOfWeek.append(selectedTag)
            tempAlarmData[index].selectedDaysOfWeek = tempAlarmData[index].selectedDaysOfWeek.sorted{ $0.rawValue < $1.rawValue }
        }
        calculateEveryDayAndSelectedDays(index: index)
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[index], changedOption: .dayOfWeek)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeEveryday(index: Int) {
        if tempAlarmData[index].isEveryDay {
            tempAlarmData[index].scale = .moreExpand
        } else {
            tempAlarmData[index].scale = .expand
        }
        tempAlarmData[index].isEveryDay.toggle()
        calculateDaysOfWeekAndSelectedDays(index: index)
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[index], changedOption: .isEveryDay)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func willDeleteAlarmData(_ indexPath: Int) {
        willDeleteCellIndex = indexPath
    }
    
    func deleteAlarmData() {
        alarmManagerUseCase.changeAlarmNotificationRequest(data: tempAlarmData[willDeleteCellIndex], changedOption: .delete)
        tempAlarmData.remove(at: willDeleteCellIndex)
        alarmDataArrayRelay.accept(tempAlarmData)
    }

    // MARK: - Output
    func getHeightForRow(_ indexPath: IndexPath) -> CGFloat {
        let cellData = alarmDataArrayRelay.value[indexPath.row]
        switch cellData.scale {
        case .normal:
            return UIScreen.main.bounds.maxY/5
        case .expand:
            return UIScreen.main.bounds.maxY/3.2
        case .moreExpand:
            return UIScreen.main.bounds.maxY/2.5
        }
    }
        
    // MARK: - Private
    private func calculateDaysOfWeekAndSelectedDays(index: Int) {
        tempAlarmData[index].selectedDaysOfWeek = AlarmTableViewCellViewModel.calculateDaysOfWeek(tempAlarmData[index].isEveryDay)
        tempAlarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(tempAlarmData[index].selectedDaysOfWeek)
        tempAlarmData[index].isOn = AlarmTableViewCellViewModel.calculateIsOn(days: tempAlarmData[index].selectedDaysOfWeek, origin: tempAlarmData[index].isOn)
    }
    
    private func calculateEveryDayAndSelectedDays(index: Int) {
        tempAlarmData[index].isEveryDay = AlarmTableViewCellViewModel.calculateEveryDay(tempAlarmData[index].selectedDaysOfWeek)
        tempAlarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(tempAlarmData[index].selectedDaysOfWeek)
        tempAlarmData[index].isOn = AlarmTableViewCellViewModel.calculateIsOn(days: tempAlarmData[index].selectedDaysOfWeek, origin: tempAlarmData[index].isOn)
    }
    
    private func resetTotalCellScaleNormal(index: Int) {
        for i in 0 ..< tempAlarmData.count {
            if i != index {
                tempAlarmData[i].scale = .normal
            }
        }
    }
}
