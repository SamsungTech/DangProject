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
    
}

protocol AlarmViewModelOutputProtocol: AnyObject {
    
}

protocol AlarmViewModelProtocol: AlarmViewModelInputProtocol, AlarmViewModelOutputProtocol {}

class AlarmViewModel: AlarmViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellViewModel]>(value: [])
    lazy var tempAlarmData: [AlarmTableViewCellViewModel] = { alarmDataArrayRelay.value }()
    var cellScaleWillExpand: Bool = false
    
    // MARK: - Init
    private var alarmManagerUseCase: DefaultAlarmManagerUseCase
    
    init(alarmManagerUseCase: DefaultAlarmManagerUseCase) {
        self.alarmManagerUseCase = alarmManagerUseCase
        bindAlarmArraySubject()
    }
    
    private func bindAlarmArraySubject() {
        alarmManagerUseCase.alarmArrayRelay
            .map { $0.map { AlarmTableViewCellViewModel.init(alarmEntity: $0) } }
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                self.alarmDataArrayRelay.accept(data)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Input
    // MARK: - Output
    
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

    func changeIsOnValue(index: Int) {
        tempAlarmData[index].isOn.toggle()
        alarmDataArrayRelay.accept(tempAlarmData)
        // if isOn, create request/ if !isOn, delete request
    }
    
    func changeDayOfTheWeek(index: Int, tag: Int) {
        if tempAlarmData[index].selectedDaysOfWeek.contains(tag) {
            guard let arrayIndex = tempAlarmData[index].selectedDaysOfWeek.firstIndex(of: tag) else { return }
            tempAlarmData[index].selectedDaysOfWeek.remove(at: arrayIndex)
        } else {
            tempAlarmData[index].selectedDaysOfWeek.append(tag)
            tempAlarmData[index].selectedDaysOfWeek = tempAlarmData[index].selectedDaysOfWeek.sorted()
        }
        calculateEveryDayAndSelectedDays(index: index)
        alarmDataArrayRelay.accept(tempAlarmData)
        // save on server
        // if isOn, update request
    }
    
    func changeEveryDay(index: Int) {
        if tempAlarmData[index].isEveryDay == true {
            tempAlarmData[index].scale = .moreExpand
            // delete request
        } else {
            tempAlarmData[index].scale = .expand
            // update request
        }
        tempAlarmData[index].isEveryDay.toggle()
        calculateDaysOfWeekAndSelectedDays(index: index)
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    private func calculateDaysOfWeekAndSelectedDays(index: Int) {
        tempAlarmData[index].selectedDaysOfWeek = AlarmTableViewCellViewModel.calculateDaysOfWeek(tempAlarmData[index].isEveryDay)
        tempAlarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(tempAlarmData[index].selectedDaysOfWeek)
    }
    
    private func calculateEveryDayAndSelectedDays(index: Int) {
        tempAlarmData[index].isEveryDay = AlarmTableViewCellViewModel.calculateEveryDay(tempAlarmData[index].selectedDaysOfWeek)
        tempAlarmData[index].selectedDays = AlarmTableViewCellViewModel.calculateSelectedDays(tempAlarmData[index].selectedDaysOfWeek)
    }
    
    private func resetTotalCellScaleNormal(index: Int) {
        for i in 0 ..< tempAlarmData.count {
            if i != index {
                tempAlarmData[i].scale = .normal
            }
        }
    }
    
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
    
    func deleteAlarmData(_ indexPath: Int) {
//        useCase.removeAlarmData(indexPath)
    }
}
