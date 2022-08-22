//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation

import RxSwift
import RxRelay

protocol GraphViewModelInputProtocol {
    
}

protocol GraphViewModelOutputProtocol {

}

protocol GraphViewModelProtocol: GraphViewModelInputProtocol, GraphViewModelOutputProtocol { }

class GraphViewModel: GraphViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        bindMonthlyTotalSugarObservable()
    }
    
    private func bindMonthlyTotalSugarObservable() {
        fetchEatenFoodsUseCase.sixMonthsTotalSugarObservable
            .subscribe(onNext: { [weak self] monthlyTotalSugar in
                let monthlyAverage = self?.calculateMonthlySugarAverage(monthlyTotalSugar)
            })
            .disposed(by: disposeBag)
    }
    
    private func calculateMonthlySugarAverage(_ monthlyTotalSugar: [TotalSugarPerMonthDomainModel]) -> [Double] {
        var currentDateComponents: DateComponents = .currentYearMonth()
        currentDateComponents.day = 1
        var monthlySugarAverage = [Double]()
        for i in 0 ..< monthlyTotalSugar.count {
            var totalSugar: Double = 0
            var dayCount: Int = 0
            
            if monthlyTotalSugar[i].month == currentDateComponents {
                dayCount = DateComponents.currentDateComponents().day!
                for day in 0 ..< dayCount {
                    totalSugar = totalSugar + monthlyTotalSugar[i].totalSugarPerMonth[day].totalSugar
                }
            } else {
                dayCount = monthlyTotalSugar[i].totalSugarPerMonth.count
                monthlyTotalSugar[i].totalSugarPerMonth.forEach {
                    totalSugar = totalSugar + $0.totalSugar
                }
            }
            
            let sugarAverage = totalSugar / Double(dayCount)
            monthlySugarAverage.append(sugarAverage.roundDecimal(to: 1))
        }
        
        return monthlySugarAverage
    }
    
}
