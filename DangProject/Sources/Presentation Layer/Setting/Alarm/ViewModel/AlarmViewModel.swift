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
    case none
}

enum SetUpCellState {
    case expand(AlarmTableViewItem)
    case normal(AlarmTableViewItem)
    case none
}

struct AlarmTableViewCellData {
    static let empty: Self = .init(alarmEntity: AlarmEntity.empty)
    var isOn: Bool
    var title: String
    var pmAm: String
    var time: String
    var selectedDays: String
    
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
    private var dateFormatter = DateFormatter()
    private var searchRowPositionFactory: SearchRowPositionFactory
    var selectedIndexRelay = BehaviorRelay<IndexPath>(value: IndexPath(row: -1, section: 0))
    var cellScaleStateRelay = BehaviorRelay<CellScaleState>(value: .none)
    var setUpCellStateRelay = BehaviorRelay<SetUpCellState>(value: .none)
    var alarmDataArrayRelay = BehaviorRelay<[AlarmTableViewCellData]>(value: [])
    
    init(searchRowPositionFactory: SearchRowPositionFactory) {
        self.searchRowPositionFactory = searchRowPositionFactory
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
    
    func branchOutSetUpCell(_ selectedIndexPath: IndexPath,
                            _ indexPath: IndexPath,
                            _ cell: AlarmTableViewItem) {
        if cellScaleStateRelay.value == .expand {
            if selectedIndexPath == indexPath {
                setUpCellStateRelay.accept(.normal(cell))
            } else {
                setUpCellStateRelay.accept(.expand(cell))
            }
        } else {
            setUpCellStateRelay.accept(.expand(cell))
        }
    }
    
    func branchOutHeightForRow(_ indexPath: IndexPath) -> CGFloat {
        if cellScaleStateRelay.value == .expand {
            if selectedIndexRelay.value == indexPath {
                return UIScreen.main.bounds.maxY/3
            } else {
                return UIScreen.main.bounds.maxY/5
            }
        } else if cellScaleStateRelay.value == .normal {
            return UIScreen.main.bounds.maxY/5
        } else {
            if selectedIndexRelay.value == indexPath {
                return UIScreen.main.bounds.maxY/2.5
            } else {
                return UIScreen.main.bounds.maxY/5
            }
        }
    }
}
