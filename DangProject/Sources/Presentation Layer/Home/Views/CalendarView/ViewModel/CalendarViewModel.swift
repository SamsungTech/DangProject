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
    func checkScrollViewDirection()
}

protocol CalendarViewModelOutputProtocol: AnyObject {
    var previousDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var nextDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDateComponents: DateComponents { get }
}

protocol CalendarViewModelProtocol: CalendarViewModelInputProtocol, CalendarViewModelOutputProtocol {}

class CalendarViewModel: CalendarViewModelProtocol {
    private let disposeBag = DisposeBag()
    var previousDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    var currentDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    var nextDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    
    var scrollDirection: ScrollDirection = .center
    
    lazy var currentDateComponents = calendarService.dateComponents
    private lazy var selectedMonth = calendarService.currentMonthData()
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
            })
            .disposed(by: disposeBag)
    }
    
    private func mergeCalendarAndEatenFoods(origin: CalendarMonthEntity, eatenFoods: [EatenFoodsPerDayDomainModel]) -> [CalendarCellViewModelEntity] {
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
    func checkScrollViewDirection() {
        switch scrollDirection {
        case .right:
            calendarService.plusMonth()
        case .center:
            return
        case .left:
            calendarService.minusMonth()
        }
        self.currentDateComponents = calendarService.dateComponents
    }
}
