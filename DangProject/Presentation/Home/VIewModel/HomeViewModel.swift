//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelInputProtocol {
    func viewDidLoad()
    func scrolledCalendarToLeft()
    func scrolledCalendarToRight()
}

protocol HomeViewModelOutputProtocol {
    var tempData: BehaviorRelay<[tempNutrient]> { get }
    var weekData: BehaviorRelay<[weekTemp]> { get }
    var mouthData: BehaviorRelay<[tempNutrient]> { get }
    var yearData: BehaviorRelay<[tempNutrient]> { get }
    var sumData: BehaviorRelay<sugarSum> { get }
    var currentXPoint: BehaviorRelay<Int> { get }
    
    func retriveBatteryData() -> BatteryEntity
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var homeUseCase: HomeUseCase
    private var calendarUseCase: CalendarUseCase
    var disposeBag = DisposeBag()
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    var weekData = BehaviorRelay<[weekTemp]>(value: [])
    var mouthData = BehaviorRelay<[tempNutrient]>(value: [])
    var yearData = BehaviorRelay<[tempNutrient]>(value: [])
    var sumData = BehaviorRelay<sugarSum>(value: .empty)
    var batteryViewCalendarData: BatteryEntity = BatteryEntity(calendar: [])
    var currentXPoint = BehaviorRelay<Int>(value: 1)
    
    init(useCase: HomeUseCase,
         calendarUseCase: CalendarUseCase) {
        self.homeUseCase = useCase
        self.calendarUseCase = calendarUseCase
    }
}

extension HomeViewModel {
    func viewDidLoad() {
        calendarUseCase.initCalculationDaysInMouth()
            .map { BatteryEntity(calendar: $0) }
            .subscribe(onNext: { data in
                self.batteryViewCalendarData = data
            })
            .disposed(by: disposeBag)
        
        homeUseCase.execute()
            .subscribe(onNext: { data in
                self.tempData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveWeekData()
            .map { $0.map { weekTemp(tempNutrient: $0) } }
            .subscribe(onNext: { data in
                self.weekData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveMouthData()
            .subscribe(onNext: { data in
                self.mouthData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveYearData()
            .subscribe(onNext: { data in
                self.yearData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.calculateSugarSum()
            .subscribe(onNext: { data in
                self.sumData.accept(data)
            })
            .disposed(by: disposeBag)
    }
    
    func scrolledCalendarToLeft() {
        calendarUseCase.createPreviousCalendarData()
            .subscribe(onNext: { [weak self] data in
                self?.batteryViewCalendarData.calendar?.insert(data, at: 0)
            })
            .disposed(by: disposeBag)
    }
    
    func scrolledCalendarToRight() {
        calendarUseCase.createNextCalendarData()
            .subscribe(onNext: { [weak self] data in
                self?.batteryViewCalendarData.calendar?.append(data)
            })
            .disposed(by: disposeBag)
    }
    
    func retriveBatteryData() -> BatteryEntity {
        return batteryViewCalendarData
    }
}
