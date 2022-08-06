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
    func changeCellActivated(index: Int)
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
    lazy var alarmData: [AlarmTableViewCellViewModel] = { alarmDataArrayRelay.value }()
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
                self?.alarmDataArrayRelay.accept(data)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Input
    func checkUserNotificationsIsFirst() {
        if UserDefaults.standard.bool(forKey: UserInfoKey.userNotificationsPermission) == false {
            alarmManagerUseCase.getRequestAuthorization()
        }
    }
    
    func expandSelectedCell(index: Int) {
        resetTotalCellScaleNormal(index: index)
        switch alarmData[index].scale {
        case .normal:
            alarmData[index].scale = .moreExpand
        case .expand:
            alarmData[index].scale = .expand
        case .moreExpand:
            alarmData[index].scale = .moreExpand
        }
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeCellActivated(index: Int) {
        resetTotalCellScaleNormal(index: index)
        
        switch alarmData[index].scale {
        case .normal:
            alarmData[index].scale = .moreExpand
            cellScaleWillExpand = true
        case .expand, .moreExpand:
            alarmData[index].scale = .normal
            cellScaleWillExpand = false
        }
        
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func addAlarmDomainModel(_ alarmDomainModel: AlarmDomainModel) {
        var alarmViewModel = AlarmTableViewCellViewModel.init(alarmDomainModel: alarmDomainModel)
        alarmViewModel.scale = .moreExpand
        
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: alarmDomainModel, changedOption: .add)
        
        alarmData.append(alarmViewModel)
        alarmData = alarmData.sorted { $0.time < $1.time }
        guard let index = self.alarmData.firstIndex(of: alarmViewModel) else { return }
        addedCellIndex = index
        resetTotalCellScaleNormal(index: addedCellIndex)
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeIsOnValue(index: Int) {
        alarmData[index].isOn.toggle()
        
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[index]),
                                                           changedOption: .isOn)
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeUserMessage(index: Int, text: String) {
        alarmData[index].message = text
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[index]),
                                                           changedOption: .message)
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeTime(index: Int, time: Date) {
        alarmData[index].time = time
        alarmData[index].timeText = .timeToString(time)
        alarmData[index].amPm = .timeToAmPm(time)
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[index]),
                                                           changedOption: .time)
        
        let willChangeAlarmData = alarmData[index]
        alarmData = alarmData.sorted { $0.time < $1.time }
        guard let dataIndex = self.alarmData.firstIndex(of: willChangeAlarmData) else { return }
        changedCellIndex = dataIndex
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeDayOfTheWeek(index: Int, tag: Int) {
        guard let selectedTag = DayOfWeek(rawValue: tag) else { return }
        if alarmData[index].selectedDaysOfWeek.contains(selectedTag) {
            guard let arrayIndex = alarmData[index].selectedDaysOfWeek.firstIndex(of: selectedTag) else { return }
            alarmData[index].selectedDaysOfWeek.remove(at: arrayIndex)
        } else {
            alarmData[index].selectedDaysOfWeek.append(selectedTag)
            alarmData[index].selectedDaysOfWeek = alarmData[index].selectedDaysOfWeek.sorted{ $0.rawValue < $1.rawValue }
        }
        calculateEveryDayAndSelectedDays(index: index)
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[index]),
                                                           changedOption: .dayOfWeek)
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func changeEveryday(index: Int) {
        alarmData[index].scale = alarmData[index].isEveryDay ? .moreExpand : .expand
        alarmData[index].isEveryDay.toggle()
        calculateDaysOfWeekAndSelectedDays(index: index)
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel: AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[index]),
                                                           changedOption: .isEveryDay)
        alarmDataArrayRelay.accept(alarmData)
    }
    
    func willDeleteAlarmData(_ indexPath: Int) {
        willDeleteCellIndex = indexPath
    }
    
    func deleteAlarmData() {
        alarmManagerUseCase.changeAlarmNotificationRequest(alarmDomainModel:
                                                            AlarmDomainModel.init(alarmTableViewCellViewModel: alarmData[willDeleteCellIndex]),
                                                           changedOption: .delete)
        alarmData.remove(at: willDeleteCellIndex)
        alarmDataArrayRelay.accept(alarmData)
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
        alarmData[index].selectedDaysOfWeek = AlarmTableViewCellViewModel.calculateDaysOfWeek(alarmData[index].isEveryDay)
        alarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(alarmData[index].selectedDaysOfWeek)
        alarmData[index].isOn = AlarmTableViewCellViewModel.calculateIsOn(days: alarmData[index].selectedDaysOfWeek, origin: alarmData[index].isOn)
    }
    
    private func calculateEveryDayAndSelectedDays(index: Int) {
        alarmData[index].isEveryDay = AlarmTableViewCellViewModel.calculateEveryDay(alarmData[index].selectedDaysOfWeek)
        alarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(alarmData[index].selectedDaysOfWeek)
        alarmData[index].isOn = AlarmTableViewCellViewModel.calculateIsOn(days: alarmData[index].selectedDaysOfWeek, origin: alarmData[index].isOn)
    }
    
    private func resetTotalCellScaleNormal(index: Int) {
        for i in 0 ..< alarmData.count {
            if i != index {
                alarmData[i].scale = .normal
            }
        }
    }
}
