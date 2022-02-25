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
}

protocol HomeViewModelOutputProtocol {
    var tempData: BehaviorRelay<[tempNutrient]> { get }
    var weekData: BehaviorRelay<[weekTemp]> { get }
    var mouthData: BehaviorRelay<[tempNutrient]> { get }
    var yearData: BehaviorRelay<[tempNutrient]> { get }
    var sumData: BehaviorRelay<sugarSum> { get }
    var batteryData: BehaviorRelay<BatteryEntity> { get }
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var useCase: HomeUseCase
    private var calendarUseCase: CalendarUseCase
    var disposeBag = DisposeBag()
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    var weekData = BehaviorRelay<[weekTemp]>(value: [])
    var mouthData = BehaviorRelay<[tempNutrient]>(value: [])
    var yearData = BehaviorRelay<[tempNutrient]>(value: [])
    var sumData = BehaviorRelay<sugarSum>(value: .empty)
    var batteryData = BehaviorRelay<BatteryEntity>(value: .empty)
    
    init(useCase: HomeUseCase, calendarUseCase: CalendarUseCase) {
        self.useCase = useCase
        self.calendarUseCase = calendarUseCase
    }
}

extension HomeViewModel {
    func viewDidLoad() {
        useCase.execute()
            .subscribe(onNext: { data in
                self.tempData.accept(data)
            })
            .disposed(by: disposeBag)
        
        useCase.retriveWeekData()
            .map { $0.map { weekTemp(tempNutrient: $0) } }
            .subscribe(onNext: { data in
                self.weekData.accept(data)
            })
            .disposed(by: disposeBag)
        
        useCase.retriveMouthData()
            .subscribe(onNext: { data in
                self.mouthData.accept(data)
            })
            .disposed(by: disposeBag)
        
        useCase.retriveYearData()
            .subscribe(onNext: { data in
                self.yearData.accept(data)
            })
            .disposed(by: disposeBag)
        
        useCase.calculateSugarSum()
            .subscribe(onNext: { data in
                self.sumData.accept(data)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.calculationDaysInMouth()
            .map { BatteryEntity(calendar: $0) }
            .subscribe(onNext: { data in
                self.batteryData.accept(data)
            })
            .disposed(by: disposeBag)
        
        
    }
}
