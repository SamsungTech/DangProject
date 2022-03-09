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
    var currentDateCGPoint: BehaviorRelay<CGPoint> { get }
    
    func retriveBatteryData() -> BatteryEntity
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var homeUseCase: HomeUseCase
    private var calendarUseCase: CalendarUseCase
    private var disposeBag = DisposeBag()
    private var currentDateYearMonth = ""
    private var batteryViewCalendarData: BatteryEntity = BatteryEntity(calendar: [])
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    var weekData = BehaviorRelay<[weekTemp]>(value: [])
    var mouthData = BehaviorRelay<[tempNutrient]>(value: [])
    var yearData = BehaviorRelay<[tempNutrient]>(value: [])
    var sumData = BehaviorRelay<sugarSum>(value: .empty)
    var currentXPoint = BehaviorRelay<Int>(value: 1)
    var currentDateCGPoint = BehaviorRelay<CGPoint>(value: CGPoint())
    var currentLineNumber = BehaviorRelay<Int>(value: 0)
    
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
            .subscribe(onNext: { [weak self] data in
                self?.batteryViewCalendarData = data
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentLine
            .subscribe(onNext: { [weak self] data in
                self?.currentLineNumber.accept(data)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentDateYearMonth
            .subscribe(onNext: { [weak self] data in
                self?.currentDateYearMonth = data
            })
            .disposed(by: disposeBag)
        
        homeUseCase.execute()
            .subscribe(onNext: { [weak self] data in
                self?.tempData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveWeekData()
            .map { $0.map { weekTemp(tempNutrient: $0) } }
            .subscribe(onNext: { [weak self] data in
                self?.weekData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveMouthData()
            .subscribe(onNext: { [weak self] data in
                self?.mouthData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveYearData()
            .subscribe(onNext: { [weak self] data in
                self?.yearData.accept(data)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.calculateSugarSum()
            .subscribe(onNext: { [weak self] data in
                self?.sumData.accept(data)
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
    
    func calculateCurrentDatePoint() {
        guard let count = batteryViewCalendarData.calendar?.count else { return }
        
        for i in 0..<count {
            if batteryViewCalendarData.calendar?[i].yearMouth == currentDateYearMonth {
                let point = CGPoint(x: UIScreen.main.bounds.maxX*CGFloat(i), y: .zero)
                currentXPoint.accept(i)
                currentDateCGPoint.accept(point)
                break
            } else {
                continue
            }
        }
    }
}

