//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//
import Foundation
import UIKit

import RxSwift
import RxRelay

enum ScrollDirection {
    case right
    case left
    case center
}

protocol CalendarViewModelInputProtocol: AnyObject {
    var scrollDirection: ScrollDirection { get set }
    func scrollViewDirectionIsVaild() -> Bool
    func changeCurrentCell(index: Int)
    func calculateCalendarViewIndex() -> Int
    func prepareToReturnSelectedView()
    func prepareToReturnCurrentView()
}

protocol CalendarViewModelOutputProtocol: AnyObject {
    var previousDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var nextDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var selectedDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDateComponents: DateComponents { get }
    var selectedDateComponents: DateComponents { get }
    func checkTodayCellColumn() -> Int
}

protocol CalendarViewModelProtocol: CalendarViewModelInputProtocol, CalendarViewModelOutputProtocol { }

class CalendarViewModel: CalendarViewModelProtocol {
    private let disposeBag = DisposeBag()
    var previousDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    var currentDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    var nextDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    lazy var selectedDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: currentDataObservable.value)
    private var initailizeSelectedDataObservable: Bool = true
    var scrollDirection: ScrollDirection = .center
    lazy var currentDateComponents = calendarService.dateComponents
    var selectedDateComponents: DateComponents = .currentDateTimeComponents()
    
    private var selectedCellChanged: Bool = false
    private var willReturnSelectedView: Bool = false
    private var willReturnCurrentView: Bool = false
    // MARK: - Init
    let calendarService: CalendarService
    let fetchEatenFoodsUsecase: FetchEatenFoodsUseCase
    
    init(calendarService: CalendarService,
         fetchEatenFoodsUsecase: FetchEatenFoodsUseCase) {
        self.calendarService = calendarService
        self.fetchEatenFoodsUsecase = fetchEatenFoodsUsecase
        bindTotalMonthEatenFoods()
    }
    
    private func bindTotalMonthEatenFoods() {
        fetchEatenFoodsUsecase.previousCurrentNextMonthsDataObservable
            .subscribe(onNext: { [weak self] totalMonths in
                guard let strongSelf = self else { return }
                if strongSelf.willReturnSelectedView {
                    self?.calendarService.changeDateComponentsToSelected()
                    self?.willReturnSelectedView = false
                }
                if strongSelf.willReturnCurrentView {
                    self?.calendarService.changeDateComponentsToCurrent()
                    self?.willReturnCurrentView = false
                }
                
                guard let previous = self?.mergeCalendarAndEatenFoods(origin: (self?.calendarService.previousMonthData())!,
                                                               eatenFoods: totalMonths[0]),
                let current = self?.mergeCalendarAndEatenFoods(origin: (self?.calendarService.currentMonthData())!,
                                                              eatenFoods: totalMonths[1]),
                let next = self?.mergeCalendarAndEatenFoods(origin: (self?.calendarService.nextMonthData())!,
                                                           eatenFoods: totalMonths[2])
                else { return }
                self?.previousDataObservable.accept(previous)
                self?.currentDataObservable.accept(current)
                self?.nextDataObservable.accept(next)
                
                if strongSelf.initailizeSelectedDataObservable {
                    self?.selectedDataObservable.accept(current)
                    self?.initailizeSelectedDataObservable = false
                }
                
                if strongSelf.selectedCellChanged {
                    self?.selectedDataObservable.accept(current)
                    self?.selectedCellChanged = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func mergeCalendarAndEatenFoods(origin: CalendarMonthEntity,
                                            eatenFoods: [EatenFoodsPerDayDomainModel]) -> [CalendarCellViewModelEntity] {
        let calendarDayEntity = origin.days
        var result: [CalendarCellViewModelEntity] = []
        var index = 0
        for i in 0 ..< 42 {
            if calendarDayEntity[i].isHidden {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i], eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel.empty))
            } else {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i],
                                                               eatenFoodsPerDayEntity: eatenFoods[index]))
                index += 1
            }
        }
        
        return result
    }
    
    // MARK: - Internal
    func scrollViewDirectionIsVaild() -> Bool {
        switch scrollDirection {
        case .right:
            calendarService.plusMonth()
            self.currentDateComponents = calendarService.dateComponents
            return true
        case .center:
            return false
        case .left:
            calendarService.minusMonth()
            self.currentDateComponents = calendarService.dateComponents
            return true
        }
    }
    
    func changeCurrentCell(index: Int) {
        let selectedCell = currentDataObservable.value[index]
        calendarService.changeSelectedDate(year: selectedCell.year,
                                           month: selectedCell.month,
                                           day: selectedCell.day)
        self.selectedDateComponents = DateComponents(year: selectedCell.year,
                                                     month: selectedCell.month,
                                                     day: selectedCell.day)
        self.selectedCellChanged = true
    }
    
    func checkTodayCellColumn() -> Int {
        for i in 0 ..< calendarService.currentMonthData().days.count {
            if calendarService.currentMonthData().days[i].isToday {
                return i
            }
        }
        return 0
    }
    
    func calculateCalendarViewIndex() -> Int {
        let tempCurrentData = currentDataObservable.value[20]
        let tempSelectedData = selectedDataObservable.value[20]
        let result = tempCurrentData.month - tempSelectedData.month
        // result > 0 : calendarViewSetContentOffset section 0
        // result = 0 : calendarViewSetContentOffset section 2 (그대로)
        // result < 0 : calendarViewSetContentOffset section 4

        if result == 0 {
            return 2
        } else if result > 0 {
            return 0
        } else {
            return 4
        }
    }
    
    func prepareToReturnSelectedView() {
        willReturnSelectedView = true
    }
    
    func prepareToReturnCurrentView() {
        willReturnCurrentView = true
    }
}
