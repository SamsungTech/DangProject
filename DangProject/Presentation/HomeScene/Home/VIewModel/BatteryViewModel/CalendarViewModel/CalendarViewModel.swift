//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

import Foundation
import RxRelay

enum CurrentDayLineState: Equatable {
    case normal(DaysCollectionViewCell)
    case hidden(DaysCollectionViewCell)
    case empty
}

enum SelectedItemFillViewState: Equatable {
    case normal(UICollectionView,
                DaysCollectionViewCell,
                IndexPath)
    case hidden(DaysCollectionViewCell)
    case empty
}

enum SelectedItemIsHiddenState: Equatable {
    case selectedTrue(UICollectionView)
    case selectedFalse(UICollectionView,
                       IndexPath)
    case empty
}

enum DeSelectedItemIsHiddenState: Equatable {
    case DeSelectedTrue
    case DeSelectedFalse(UICollectionView,
                         IndexPath)
}

enum YearMonthState: Equatable {
    case match(UICollectionView,
               IndexPath,
               DaysCollectionViewCell)
    case differ
}

struct SelectedCalendarCellEntity: Equatable {
    static let empty: Self = .init(yearMonth: "",
                                   indexPath: IndexPath(item: 0, section: 0))
    
    var yearMonth: String?
    var indexPath: IndexPath?
    
    init(yearMonth: String, indexPath: IndexPath) {
        self.yearMonth = yearMonth
        self.indexPath = indexPath
    }
}

struct CalendarMonthDangEntity {
    static let empty: Self = .init(calendarMonthDang: [])
    
    var calendarMonthDang: [MonthDangEntity]
    
    init(calendarMonthDang: [MonthDangEntity]) {
        self.calendarMonthDang = calendarMonthDang
    }
}

struct CalendarStackViewEntity: Equatable {
    static let empty: Self = .init(batteryEntity: .empty)
    
    var yearMonth: String
    var daysArray: [String]
    var isHiddenArray: [Bool]
    var dangArray: [Double]
    var maxDangArray: [Double]
    var isCurrentDayArray: [Bool]
}

extension CalendarStackViewEntity {
    init(batteryEntity: BatteryEntity) {
        self.yearMonth = batteryEntity.yearMonth
        self.daysArray = batteryEntity.daysArray
        self.isHiddenArray = batteryEntity.isHiddenArray
        self.dangArray = batteryEntity.dangArray
        self.maxDangArray = batteryEntity.maxDangArray
        self.isCurrentDayArray = batteryEntity.isCurrentDayArray
    }
}

protocol CalendarViewModelInputProtocol: AnyObject {
    func compareCurrentDayCellData(indexPath: IndexPath,
                                   yearMonth: String,
                                   cell: DaysCollectionViewCell,
                                   currentCount: Int,
                                   currentYearMonth: String)
    func compareSelectedDayCellData(indexPath: IndexPath,
                                    yearMonth: String,
                                    cell: DaysCollectionViewCell,
                                    collectionView: UICollectionView,
                                    selectedCellIndexPath: Int,
                                    selectedCellYearMonth: String)
    func calculateSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                            indexPath: IndexPath)
    func calculateDeSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                              indexPath: IndexPath)
    func compareSelectedYearMonthData(collectionView: UICollectionView,
                                      selectedYearMonth: String,
                                      indexPath: IndexPath,
                                      cell: DaysCollectionViewCell)
}

protocol CalendarViewModelOutputProtocol: AnyObject {
    var calendarData: BehaviorRelay<CalendarStackViewEntity> { get }
    var currentDayCellLineViewState: BehaviorRelay<CurrentDayLineState> { get }
    var selectedCellFillViewState: BehaviorRelay<SelectedItemFillViewState> { get }
    var selectedYearMonthState: BehaviorRelay<YearMonthState> { get }
    var selectedCalendarCellIsHidden: BehaviorRelay<SelectedItemIsHiddenState> { get }
    var deSelectedCalendarCellIsHidden: BehaviorRelay<DeSelectedItemIsHiddenState> { get }
}

protocol CalendarViewModelProtocol: CalendarViewModelInputProtocol, CalendarViewModelOutputProtocol {}

class CalendarViewModel: CalendarViewModelProtocol {
    var calendarData = BehaviorRelay<CalendarStackViewEntity>(value: .empty)
    var currentDayCellLineViewState = BehaviorRelay<CurrentDayLineState>(value: .empty)
    var selectedCellFillViewState = BehaviorRelay<SelectedItemFillViewState>(value: .empty)
    var selectedYearMonthState = BehaviorRelay<YearMonthState>(value: .differ)
    var selectedCalendarCellIsHidden = BehaviorRelay<SelectedItemIsHiddenState>(value: .empty)
    var deSelectedCalendarCellIsHidden = BehaviorRelay<DeSelectedItemIsHiddenState>(value: .DeSelectedTrue)
    
    init(calendarData: BatteryEntity) {
        self.calendarData.accept(
            CalendarStackViewEntity(
                batteryEntity: calendarData
            )
        )
    }
}

extension CalendarViewModel {
    func compareCurrentDayCellData(indexPath: IndexPath,
                                   yearMonth: String,
                                   cell: DaysCollectionViewCell,
                                   currentCount: Int,
                                   currentYearMonth: String) {
        if indexPath.item == currentCount && currentYearMonth == yearMonth {
            currentDayCellLineViewState.accept(
                .normal(cell)
            )
        } else {
            currentDayCellLineViewState.accept(
                .hidden(cell)
            )
        }
    }
    
    func compareSelectedDayCellData(indexPath: IndexPath,
                                    yearMonth: String,
                                    cell: DaysCollectionViewCell,
                                    collectionView: UICollectionView,
                                    selectedCellIndexPath: Int,
                                    selectedCellYearMonth: String) {
        if indexPath.item == selectedCellIndexPath && selectedCellYearMonth == yearMonth {
            selectedCellFillViewState.accept(
                .normal(collectionView, cell,
                        indexPath)
            )
        } else {
            selectedCellFillViewState.accept(
                .hidden(cell)
            )
        }
    }
    
    func calculateSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                            indexPath: IndexPath) {
        let isHidden = calendarData.value.isHiddenArray[indexPath.item]
        
        switch isHidden {
        case true:
            selectedCalendarCellIsHidden.accept(
                .selectedTrue(collectionView)
            )
        case false:
            selectedCalendarCellIsHidden.accept(
                .selectedFalse(collectionView,
                               indexPath)
            )
        }
    }
    
    func calculateDeSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                              indexPath: IndexPath) {
        let isHidden = calendarData.value.isHiddenArray[indexPath.item]
        
        switch isHidden {
        case true:
            deSelectedCalendarCellIsHidden.accept(
                .DeSelectedTrue
            )
        case false:
            deSelectedCalendarCellIsHidden.accept(
                .DeSelectedFalse(collectionView,
                                 indexPath)
            )
        }
    }
    
    func compareSelectedYearMonthData(collectionView: UICollectionView,
                                      selectedYearMonth: String,
                                      indexPath: IndexPath,
                                      cell: DaysCollectionViewCell) {
        if selectedYearMonth == calendarData.value.yearMonth {
            selectedYearMonthState.accept(.match(collectionView, indexPath, cell))
        } else {
            selectedYearMonthState.accept(.differ)
        }
    }
}
