//
//  AlarmTableViewItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/27.
//

import UIKit

import RxSwift
import RxRelay

enum ExpandCellScaleState {
    case expand
    case moreExpand
}

struct AlarmItemEntity {
    static let empty: Self = .init(alarmTableViewCellData: AlarmTableViewCellData.empty)
    var alarmIsOn: Bool
    var message: String
    var pmAm: String
    var selectedTime: String
    var selectedDays: String
    
    init(alarmTableViewCellData: AlarmTableViewCellData) {
        self.alarmIsOn = alarmTableViewCellData.isOn
        self.message = alarmTableViewCellData.title
        self.pmAm = alarmTableViewCellData.pmAm
        self.selectedTime = alarmTableViewCellData.time
        self.selectedDays = alarmTableViewCellData.selectedDays
    }
}

protocol AlarmTableViewItemViewModelInputProtocol: AnyObject {
    func branchOutSwitchValue(_ value: UISwitch)
    func branchOutMoreExpandState()
}

protocol AlarmTableViewItemViewModelOutputProtocol: AnyObject {
    var switchValueRelay: BehaviorRelay<Bool> { get }
    var cellScaleStateRelay: BehaviorRelay<CellScaleState> { get }
    var expandStateRelay: BehaviorRelay<ExpandCellScaleState> { get }
    var alarmEntityRelay: BehaviorRelay<AlarmItemEntity> { get }
}

protocol AlarmTableViewItemViewModelProtocol: AlarmTableViewItemViewModelInputProtocol, AlarmTableViewItemViewModelOutputProtocol {}

class AlarmTableViewItemViewModel: AlarmTableViewItemViewModelProtocol {
    private let disposeBag = DisposeBag()
    var switchValueRelay = BehaviorRelay<Bool>(value: false)
    var cellScaleStateRelay = BehaviorRelay<CellScaleState>(value: .none)
    var expandStateRelay = BehaviorRelay<ExpandCellScaleState>(value: .expand)
    var alarmEntityRelay = BehaviorRelay<AlarmItemEntity>(value: .empty)
    
    init(alarmItemEntity: AlarmTableViewCellData) {
        alarmEntityRelay.accept(
            AlarmItemEntity(
                alarmTableViewCellData: alarmItemEntity
            )
        )
        
        switchValueRelay.accept(alarmEntityRelay.value.alarmIsOn)
    }
    
    func branchOutSwitchValue(_ value: UISwitch) {
        if value.isOn == true {
            switchValueRelay.accept(true)
        } else {
            switchValueRelay.accept(false)
        }
    }
    
    func branchOutMoreExpandState() {
        if expandStateRelay.value == .expand {
            expandStateRelay.accept(.moreExpand)
        } else {
            expandStateRelay.accept(.expand)
        }
    }
}
