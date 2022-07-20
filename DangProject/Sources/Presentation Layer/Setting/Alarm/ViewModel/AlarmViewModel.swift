//
//  AlramViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import UIKit

import RxSwift
import RxRelay

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
    private var useCase: SettingUseCase
    private var dateFormatter = DateFormatter()
    
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellViewModel]>(value: [])
    lazy var tempAlarmData: [AlarmTableViewCellViewModel] = { alarmDataArrayRelay.value }()
    var cellScaleWillExpand: Bool = false
    
    init(useCase: SettingUseCase) {
        self.useCase = useCase
        bindAlarmArraySubject()
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
    
    func changeCellScaleMoreExpand(index: Int) {
        switch tempAlarmData[index].scale {
        case .expand:
            tempAlarmData[index].scale = .moreExpand
        case .moreExpand:
            tempAlarmData[index].scale = .expand
        case .normal:
            break
        }
        
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeIsOnValue(index: Int) {
        tempAlarmData[index].isOn.toggle()
        alarmDataArrayRelay.accept(tempAlarmData)
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
    
    func deleteAlarmData(_ indexPath: IndexPath) {
        useCase.removeAlarmData(indexPath)
    }
}

extension AlarmViewModel {
    private func bindAlarmArraySubject() {
        useCase.alarmArrayRelay
            .map { $0.map { AlarmTableViewCellViewModel.init(alarmEntity: $0) } }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.alarmDataArrayRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
