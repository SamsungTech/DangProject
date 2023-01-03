//
//  CalendarViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/26.
//

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
    var animationIsNeeded: Bool { get }
    func scrollViewDirectionIsVaild() -> Bool
    func selectedCellIsValid(index: Int) -> Bool
    func calculateCalendarViewIndex() -> Int
    func nextMonthIsBiggerThanNow() -> Bool
    func nextMonthIsNow() -> Bool
    func prepareToShowSelectedView()
    func prepareToShowCurrentView()
}

protocol CalendarViewModelOutputProtocol: AnyObject {
    var nextDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var previousDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var selectedDataObservable: BehaviorRelay<[CalendarCellViewModelEntity]> { get }
    var currentDateComponents: DateComponents { get }
    var selectedDateComponents: DateComponents { get }
    func checkTodayCellColumn() -> Int
    func checkSelectedCellNeedFetch(date: DateComponents) -> Bool
}

protocol CalendarViewModelProtocol: CalendarViewModelInputProtocol, CalendarViewModelOutputProtocol { }

class CalendarViewModel: CalendarViewModelProtocol {
    private let disposeBag = DisposeBag()
    
    var nextDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    
    var previousDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    
    var currentDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: [])
    
    
    lazy var selectedDataObservable = BehaviorRelay<[CalendarCellViewModelEntity]>(value: currentDataObservable.value)
    
    private var initailizeSelectedDataObservable: Bool = true
    
    var scrollDirection: ScrollDirection = .center
    
    lazy var currentDateComponents = calendarService.dateComponents
    var selectedDateComponents: DateComponents = .currentDateTimeComponents()
    var animationIsNeeded: Bool = true
    
    private var selectedCellChanged: Bool = false
    private var selectedCalendarWillShow: Bool = false
    private var currentCalendarWillShow: Bool = false
    private var targetSugarRelay = BehaviorRelay<Int>(value: 0)
    
    // MARK: - Init
    let calendarService: CalendarService
    let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    let profileManagerUseCase: ProfileManagerUseCase
    
    private var totalMonthRelay = BehaviorRelay<[[EatenFoodsPerDayDomainModel]]>(value: [])
    
    init(calendarService: CalendarService,
         fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.calendarService = calendarService
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManagerUseCase = profileManagerUseCase
        bindTotalMonthEatenFoodsAndTargetSugar()
    }
    
    private func bindTotalMonthEatenFoodsAndTargetSugar() {
        let targetSugarObservable = PublishSubject<Int>()
        let eatenFoodsObservable = PublishSubject<[[EatenFoodsPerDayDomainModel]]>()
        
        fetchEatenFoodsUseCase.totalMonthsDataObservable
            .subscribe(onNext: { totalMonths in
                eatenFoodsObservable.onNext(totalMonths)
            })
            .disposed(by: disposeBag)
        
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { profileData in
                targetSugarObservable.onNext(profileData.sugarLevel)
            })
            .disposed(by: disposeBag)
        
        Observable.combineLatest(eatenFoodsObservable, targetSugarObservable)
            .subscribe(onNext: { [weak self] totalMonths, targetSugar in
                guard let strongSelf = self else { return }
                self?.targetSugarRelay.accept(targetSugar)
                strongSelf.acceptCalendarDataObservable(totalMonths)
            })
            .disposed(by: disposeBag)
    }
    
    private func acceptCalendarDataObservable(_ totalMonths: [[EatenFoodsPerDayDomainModel]]) {
        self.checkSelectedCalendarWillShow()
        self.checkCurrentCalendarWillShow()
        
        let currentMonth = branchOutTotalMonthsDataIsEmpty(
            totalMonths: totalMonths[1],
            calendar: self.calendarService.currentMonthData()
        )
        
        self.previousDataObservable.accept(
            branchOutTotalMonthsDataIsEmpty(
                totalMonths: totalMonths[0],
                calendar: self.calendarService.previousMonthData()
            )
        )
        
        self.currentDataObservable.accept(currentMonth)
        
        self.nextDataObservable.accept(
            branchOutTotalMonthsDataIsEmpty(
                totalMonths: totalMonths[2],
                calendar: self.calendarService.nextMonthData()
            )
        )
        
        if initailizeSelectedDataObservable {
            self.selectedDataObservable.accept(currentMonth)
            self.initailizeSelectedDataObservable = false
        }
        
        if selectedCellChanged {
            self.selectedDataObservable.accept(currentMonth)
            self.selectedCellChanged = false
        }
    }
    
    private func branchOutTotalMonthsDataIsEmpty(totalMonths: [EatenFoodsPerDayDomainModel],
                                                 calendar: CalendarMonthEntity) -> [CalendarCellViewModelEntity] {
        if totalMonths.isEmpty {
            return self.returnCalendarEntity(calendar: calendar)
        } else {
            return self.mergeCalendarAndEatenFoods(calendar: calendar, with: totalMonths)
        }
    }
    
    private func mergeCalendarAndEatenFoods(calendar: CalendarMonthEntity,
                                            with eatenFoods: [EatenFoodsPerDayDomainModel]) -> [CalendarCellViewModelEntity] {
        let calendarDayEntity = calendar.days
        var result: [CalendarCellViewModelEntity] = []
        var index = 0
        for i in 0 ..< 42 {
            if calendarDayEntity[i].isHidden {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i],
                                                               eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel.empty,
                                                               targetSugar: targetSugarRelay.value))
            } else {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i],
                                                               eatenFoodsPerDayEntity: eatenFoods[index],
                                                               targetSugar: targetSugarRelay.value))
                index += 1
            }
        }
        return result
    }
    
    private func returnCalendarEntity(calendar: CalendarMonthEntity) -> [CalendarCellViewModelEntity] {
        let calendarDayEntity = calendar.days
        var result: [CalendarCellViewModelEntity] = []
        var index = 0
        for i in 0 ..< 42 {
            if calendarDayEntity[i].isHidden {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i],
                                                               eatenFoodsPerDayEntity: EatenFoodsPerDayDomainModel.empty,
                                                               targetSugar: targetSugarRelay.value))
            } else {
                result.append(CalendarCellViewModelEntity.init(calendarDayEntity: calendarDayEntity[i] ))
                index += 1
            }
        }
        return result
    }
    
    private func checkSelectedCalendarWillShow() {
        if selectedCalendarWillShow {
            calendarService.changeDateComponentsToSelected()
            selectedCalendarWillShow = false
        }
    }
    
    private func checkCurrentCalendarWillShow() {
        if currentCalendarWillShow {
            calendarService.changeDateComponentsToCurrent()
            currentCalendarWillShow = false
        }
    }
    
    // MARK: - Internal
    func scrollViewDirectionIsVaild() -> Bool {
        switch scrollDirection {
        case .right:
            self.animationIsNeeded = true
            calendarService.plusMonth()
            self.currentDateComponents = calendarService.dateComponents
            return true
        case .center:
            self.animationIsNeeded = false
            return false
        case .left:
            self.animationIsNeeded = true
            calendarService.minusMonth()
            self.currentDateComponents = calendarService.dateComponents
            return true
        }
    }
    
    func selectedCellIsValid(index: Int) -> Bool {
        let selectedCell = currentDataObservable.value[index]
        let selectedDate = DateComponents(year: selectedCell.year,
                                          month: selectedCell.month,
                                          day: selectedCell.day)
        if checkSelectedCellNeedFetch(date: selectedDate) {
            self.animationIsNeeded = false
            self.scrollDirection = .center
            calendarService.changeSelectedDate(year: selectedCell.year,
                                               month: selectedCell.month,
                                               day: selectedCell.day)
            self.selectedDateComponents = DateComponents(year: selectedCell.year,
                                                         month: selectedCell.month,
                                                         day: selectedCell.day)
            self.selectedCellChanged = true
            return true
        } else {
            return false
        }
    }
    
    func checkTodayCellColumn() -> Int {
        let currentMonthDays = calendarService.currentMonthData().days
        for i in 0 ..< currentMonthDays.count {
            if currentMonthDays[i].isToday {
                return i/7
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
    
    func nextMonthIsBiggerThanNow() -> Bool {
        let now: DateComponents = .currentYearMonth()
        let nextCalendar: DateComponents = calendarService.dateComponents
        
        if nextCalendar.year! > now.year! {
            return true
        } else if nextCalendar.year! < now.year! {
            return false
        } else {
            if nextCalendar.month! > now.month! {
                return true
            } else {
                return false
            }
        }
    }
    
    func nextMonthIsNow() -> Bool {
        var current: DateComponents = .currentDateComponents()
        current.day = 1
        if self.currentDateComponents == current {
            return true
        } else {
            return false
        }
    }
    
    func prepareToShowSelectedView() {
        selectedCalendarWillShow = true
    }
    
    func prepareToShowCurrentView() {
        currentCalendarWillShow = true
    }
    
    func checkSelectedCellNeedFetch(date: DateComponents) -> Bool {
        let now: DateComponents = .currentDateComponents()

        if date.year! > now.year! {
            return false
        }
        if date.year! == now.year! {
            if date.month! > now.month! {
                return false
            } else if date.month! == now.month {
                if date.day! > now.day! {
                    return false
                }
            }
        }
        return true
    }
}
