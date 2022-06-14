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
    lazy var tempAlarmData: [AlarmTableViewCellData] = {
        alarmDataArrayRelay.value
    }()
    
    init(useCase: SettingUseCase,
         searchRowPositionFactory: SearchRowPositionFactory) {
        self.useCase = useCase
        self.searchRowPositionFactory = searchRowPositionFactory
        bindAlarmArraySubject()
    }
    
    func viewDidLoad() {
        useCase?.startAlarmData()
    }
    
    func cellScaleWillChange(index: IndexPath) {
        resetAllCellScale(indexPath: index)
        for i in 0 ..< tempAlarmData.count {
            if i == index.row {
                if tempAlarmData[i].scale == .normal {
                    tempAlarmData[i].scale = .expand
                } else {
                    tempAlarmData[i].scale = .normal
                }
            }
            print("\(i). cellScaleWillChange")
        }
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeMoreExpand(index: IndexPath) {
        for i in 0..<tempAlarmData.count {
            if tempAlarmData[i].scale == .expand {
                tempAlarmData[i].scale = .moreExpand
            } else if tempAlarmData[i].scale == .moreExpand {
                tempAlarmData[i].scale = .expand
            } else {
                tempAlarmData[i].scale = .normal
            }
            print("\(i). changeMoreExpand")
        }
        
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    func changeIsOnValue(index: IndexPath) {
//        var tempDataArray = alarmDataArrayRelay.value
        for i in 0..<tempAlarmData.count {
            if i == index.row {
                tempAlarmData[i].isOn.toggle()
            }
            print("\(i). changeIsOnValue")
        }
        alarmDataArrayRelay.accept(tempAlarmData)
    }
    
    private func resetAllCellScale(indexPath: IndexPath) {
        for index in 0 ..< tempAlarmData.count {
            if index != indexPath.row {
                tempAlarmData[index].scale = .normal
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
