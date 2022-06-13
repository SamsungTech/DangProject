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
    private var useCase: SettingUseCase?
    private var dateFormatter = DateFormatter()
    private var searchRowPositionFactory: SearchRowPositionFactory
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellData]>(value: [])
    var tempAlarmData = [AlarmTableViewCellData]()
    
    init(useCase: SettingUseCase,
         searchRowPositionFactory: SearchRowPositionFactory) {
        self.useCase = useCase
        self.searchRowPositionFactory = searchRowPositionFactory
    }
    
    func viewDidLoad() {
        useCase?.startAlarmData()
        bindAlarmArraySubject()
    }
    
    func cellScaleWillChange(index: IndexPath) {
        var tempDataArray = alarmDataArrayRelay.value
        for i in 0 ..< tempDataArray.count {
            if i == index.row {
                if tempDataArray[i].scale == .normal {
                    tempDataArray[i].scale = .expand
                } else {
                    tempDataArray[i].scale = .normal
                }
            } else {
                tempDataArray[i].scale = .normal
            }
        }
        alarmDataArrayRelay.accept(tempDataArray)
    }
    
    func changeMoreExpand(index: IndexPath) {
        var tempDataArray = alarmDataArrayRelay.value
        for i in 0..<tempDataArray.count {
            if tempDataArray[i].scale == .expand {
                tempDataArray[i].scale = .moreExpand
            } else if tempDataArray[i].scale == .moreExpand {
                tempDataArray[i].scale = .expand
            } else {
                tempDataArray[i].scale = .normal
            }
        }
        alarmDataArrayRelay.accept(tempDataArray)
    }
    
    func changeIsOnValue(index: IndexPath) {
        var tempDataArray = alarmDataArrayRelay.value
        for i in 0..<tempDataArray.count {
            if i == index.row {
                tempDataArray[i].isOn.toggle()
            }
        }
        
        alarmDataArrayRelay.accept(tempDataArray)
    }
    
    func resetAllCellScale(indexPath: IndexPath) {
        var alarmData = tempAlarmData
        for index in 0 ..< alarmData.count {
            if index != indexPath.row {
                alarmData[index].scale = .normal
            }
        }
    }
    
    func getHeightForRow(_ indexPath: IndexPath) -> CGFloat {
        let cellData = alarmDataArrayRelay.value[indexPath.row]
        switch cellData.scale {
        case .normal:
            return UIScreen.main.bounds.maxY/5
        case .expand:
            return UIScreen.main.bounds.maxY/3.8
        case .moreExpand:
            return UIScreen.main.bounds.maxY/3
        }
    }
    
    func deleteAlarmData(_ indexPath: IndexPath) {
        useCase?.removeAlarmData(indexPath)
    }
}

extension AlarmViewModel {
    private func bindAlarmArraySubject() {
        useCase?.alarmArrayRelay
            .map { $0.map { AlarmTableViewCellData.init(alarmEntity: $0) } }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.alarmDataArrayRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
