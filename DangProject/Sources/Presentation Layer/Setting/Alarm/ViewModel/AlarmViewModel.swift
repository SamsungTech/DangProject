//
//  AlramViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/25.
//

import Foundation
import UIKit

import RxSwift
import RxRelay

enum NavigationBarEvent {
    case back
    case add
}

enum CellScaleState {
    case expand
    case normal
    case moreExpand
}

struct AlarmTableViewCellData {
    static let empty: Self = .init(alarmEntity: AlarmEntity.empty)
    var isOn: Bool
    var title: String
    var pmAm: String
    var time: String
    var selectedDays: String
    var cellScale: CellScaleState = .normal
    
    init(alarmEntity: AlarmEntity) {
        self.isOn = alarmEntity.isOn
        self.title = alarmEntity.title
        self.pmAm = .calculatePmAm(alarmEntity.time)
        self.time = .calculateTime(alarmEntity.time)
        self.selectedDays = alarmEntity.selectedDays
    }
}

protocol AlarmViewModelInputProtocol: AnyObject {
    
}

protocol AlarmViewModelOutputProtocol: AnyObject {
    var selectedIndexRelay: BehaviorRelay<IndexPath> { get }
    var cellScaleStateRelay: BehaviorRelay<CellScaleState> { get }
}

protocol AlarmViewModelProtocol: AlarmViewModelInputProtocol, AlarmViewModelOutputProtocol {}

class AlarmViewModel: AlarmViewModelProtocol {
    private let disposeBag = DisposeBag()
    private var useCase: SettingUseCase?
    private var dateFormatter = DateFormatter()
    private var searchRowPositionFactory: SearchRowPositionFactory
    var selectedIndexRelay = BehaviorRelay<IndexPath>(value: IndexPath(row: -1, section: 0))
    var cellScaleStateRelay = BehaviorRelay<CellScaleState>(value: .normal)
    
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellData]>(value: [])
    
    init(useCase: SettingUseCase,
         searchRowPositionFactory: SearchRowPositionFactory) {
        self.useCase = useCase
        self.searchRowPositionFactory = searchRowPositionFactory
    }
    
    func viewDidLoad() {
        useCase?.startAlarmData()
        bindAlarmArraySubject()
    }
    
    func branchOutSelectedIndex(_ indexPath: IndexPath) {
        if selectedIndexRelay.value == indexPath {
            branchOutIsSelected()
        } else {
            cellScaleStateRelay.accept(.expand)
        }
        selectedIndexRelay.accept(indexPath)
    }
    
    func branchOutIsSelected() {
        if cellScaleStateRelay.value == .expand {
            cellScaleStateRelay.accept(.normal)
        } else {
            cellScaleStateRelay.accept(.expand)
        }
    }
    
    func branchOutMoreExpand() {
        if cellScaleStateRelay.value == .expand {
            cellScaleStateRelay.accept(.moreExpand)
        } else {
            cellScaleStateRelay.accept(.expand)
        }
    }
        
    func getHeightForRow(_ indexPath: IndexPath) -> CGFloat {
        let cellData = alarmDataArrayRelay.value[indexPath.row]
        switch cellData.cellScale {
        case .normal:
            return UIScreen.main.bounds.maxY/5
        case .expand:
            return UIScreen.main.bounds.maxY/3
        case .moreExpand:
            return UIScreen.main.bounds.maxY/2.5
        }
    }
    
    func cellScaleWillChange(index: IndexPath) {
        var tempDataArr = alarmDataArrayRelay.value
        for i in 0 ..< tempDataArr.count {
            if i == index.row {
                if tempDataArr[i].cellScale == .normal {
                    tempDataArr[i].cellScale = .expand
                } else {
                    tempDataArr[i].cellScale = .normal
                }
            } else {
                tempDataArr[i].cellScale = .normal
            }
        }
        alarmDataArrayRelay.accept(tempDataArr)
    }
    
    func deleteAlarmData(_ indexPath: IndexPath) {
        useCase?.removeAlarmData(indexPath)
    }
    
    func insertAlarmData(_ indexPath: IndexPath,
                         _ alarmEntity: AlarmEntity) {
        useCase?.insertAlarmData(indexPath, alarmEntity)
    }
    
    func searchRowsPosition(alarmData: AlarmEntity) -> IndexPath {
        var result = IndexPath(row: 0, section: 0)
        if let data = useCase?.alarmArray {
            result = searchRowPositionFactory.calculateRowPoint(alarmData, data)
        }
        return result
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
