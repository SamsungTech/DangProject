//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

import Foundation
import RxRelay

enum CurrentDayLineState {
    case normal(DaysCollectionViewCell)
    case hidden(DaysCollectionViewCell)
    case empty
}

enum SelectedItemFillViewState {
    case normal(UICollectionView, DaysCollectionViewCell, IndexPath)
    case hidden(DaysCollectionViewCell)
    case empty
}

enum SelectedItemIsHiddenState {
    case selectedTrue(UICollectionView)
    case selectedFalse(UICollectionView, IndexPath)
    case empty
}

enum DeSelectedItemIsHiddenState {
    case DeSelectedTrue
    case DeSelectedFalse(UICollectionView, IndexPath)
}

enum YearMonthState {
    case match(UICollectionView, IndexPath, DaysCollectionViewCell)
    case differ
}

struct SelectedCalendarCellEntity {
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
    
    var calendarMonthDang: [MonthDangEntity]?
    
    init(calendarMonthDang: [MonthDangEntity]?) {
        self.calendarMonthDang = calendarMonthDang
    }
}

struct CalendarStackViewEntity {
    static let empty: Self = .init(batteryEntity: .empty)
    
    var yearMonth: String?
    var daysArray: [String]?
    var isHiddenArray: [Bool]?
    var dangArray: [Double]?
    var maxDangArray: [Double]?
    var isCurrentDayArray: [Bool]?
    
    init(batteryEntity: BatteryEntity?) {
        guard let yearMonth = batteryEntity?.yearMonth,
              let daysArray = batteryEntity?.daysArray,
              let isHiddenArray = batteryEntity?.isHiddenArray,
              let dangArray = batteryEntity?.dangArray,
              let maxDangArray = batteryEntity?.maxDangArray,
              let isCurrentDayArray = batteryEntity?.isCurrentDayArray else { return }
        self.yearMonth = yearMonth
        self.daysArray = daysArray
        self.isHiddenArray = isHiddenArray
        self.dangArray = dangArray
        self.maxDangArray = maxDangArray
        self.isCurrentDayArray = isCurrentDayArray
    }
}

class CalendarViewModel {
    var calendarData = BehaviorRelay<CalendarStackViewEntity>(value: .empty)
    var currentDayCellLineViewState = BehaviorRelay<CurrentDayLineState>(value: .empty)
    var selectedCellFillViewState = BehaviorRelay<SelectedItemFillViewState>(value: .empty)
    var selectedYearMonthState = BehaviorRelay<YearMonthState>(value: .differ)
    var selectedCalendarCellIsHidden = BehaviorRelay<SelectedItemIsHiddenState>(value: .empty)
    var deSelectedCalendarCellIsHidden = BehaviorRelay<DeSelectedItemIsHiddenState>(value: .DeSelectedTrue)
    
    init(calendarData: BatteryEntity) {
        self.calendarData.accept(CalendarStackViewEntity(batteryEntity: calendarData))
    }
}

extension CalendarViewModel {
    func compareCurrentDayCellData(indexPath: IndexPath,
                                   yearMonth: String,
                                   cell: DaysCollectionViewCell,
                                   currentCount: Int,
                                   currentYearMonth: String) {
        if indexPath.item == currentCount && currentYearMonth == yearMonth {
            currentDayCellLineViewState.accept(.normal(cell))
        } else {
            currentDayCellLineViewState.accept(.hidden(cell))
        }
    }
    
    func compareSelectedDayCellData(indexPath: IndexPath,
                                    yearMonth: String,
                                    cell: DaysCollectionViewCell,
                                    collectionView: UICollectionView,
                                    selectedCellIndexPath: Int,
                                    selectedCellYearMonth: String) {
        if indexPath.item == selectedCellIndexPath && selectedCellYearMonth == yearMonth {
            selectedCellFillViewState.accept(.normal(collectionView, cell, indexPath))
        } else {
            selectedCellFillViewState.accept(.hidden(cell))
        }
    }
    
    func calculateSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                            indexPath: IndexPath) {
        let isHidden = calendarData.value.isHiddenArray?[indexPath.item]
        
        switch isHidden {
        case true:
            selectedCalendarCellIsHidden.accept(.selectedTrue(collectionView))
        case false:
            selectedCalendarCellIsHidden.accept(.selectedFalse(collectionView, indexPath))
        default: break
        }
    }
    
    func calculateDeSelectedItemIsHiddenValue(collectionView: UICollectionView,
                                              indexPath: IndexPath) {
        let isHidden = calendarData.value.isHiddenArray?[indexPath.item]
        
        switch isHidden {
        case true:
            deSelectedCalendarCellIsHidden.accept(.DeSelectedTrue)
        case false:
            deSelectedCalendarCellIsHidden.accept(.DeSelectedFalse(collectionView, indexPath))
        default: break
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
