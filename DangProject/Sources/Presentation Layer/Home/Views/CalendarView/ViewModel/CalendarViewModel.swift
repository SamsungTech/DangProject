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
        
        let previousCalendar = self.calendarService.previousMonthData()
        let currentCalendar = self.calendarService.currentMonthData()
        let nextCalendar = self.calendarService.nextMonthData()
        
        var oneMonthBefore: [CalendarCellViewModelEntity] = []
        var currentMonth: [CalendarCellViewModelEntity] = []
        var nextMonth: [CalendarCellViewModelEntity] = []
        
        if totalMonths[0].isEmpty {
            oneMonthBefore = self.returnCalendarEntity(calendar: previousCalendar)
        } else {
            oneMonthBefore = self.mergeCalendarAndEatenFoods(calendar: previousCalendar, with: totalMonths[0])
        }
        if totalMonths[1].isEmpty {
            currentMonth = self.returnCalendarEntity(calendar: currentCalendar)
        } else {
            currentMonth = self.mergeCalendarAndEatenFoods(calendar: currentCalendar, with: totalMonths[1])
        }
        if totalMonths[2].isEmpty {
            nextMonth = self.returnCalendarEntity(calendar: nextCalendar)
        } else {
            nextMonth = self.mergeCalendarAndEatenFoods(calendar: nextCalendar, with: totalMonths[2])
        }
        self.previousDataObservable.accept(oneMonthBefore)
        self.currentDataObservable.accept(currentMonth)
        self.nextDataObservable.accept(nextMonth)
        
        if initailizeSelectedDataObservable {
            self.selectedDataObservable.accept(currentMonth)
            self.initailizeSelectedDataObservable = false
        }
        
        if selectedCellChanged {
            self.selectedDataObservable.accept(currentMonth)
            self.selectedCellChanged = false
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
        guard let nowYear = now.year,
              let nowMonth = now.month,
              let nextYear = nextCalendar.year,
              let nextMonth = nextCalendar.month else { return false }
        if nextYear > nowYear {
            return true
        } else if nextYear < nowYear {
            return false
        } else {
            if nextMonth > nowMonth {
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
        
        guard let nowYear = now.year,
              let nowMonth = now.month,
              let nowDay = now.day,
              let dateYear = date.year,
              let dateMonth = date.month,
              let dateDay = date.day else { return false }
        
        if dateYear > nowYear {
            return false
        }
        if dateYear == nowYear {
            if dateMonth > nowMonth {
                return false
            } else if dateMonth == nowMonth {
                if dateDay > nowDay {
                    return false
                }
            }
        }
        return true
    }
}
