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
            .subscribe(onNext: { [weak self] dateComponents, monthlyTotalSugar in
                let monthlyAverage = self?.calculateMonthlySugarAverage(monthlyTotalSugar)
                let dailyAverage = self?.calculateDailySugarAverage(monthlyTotalSugar: monthlyTotalSugar, selectedDateComponents: dateComponents)
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
    
    private func calculateDailySugarAverage(monthlyTotalSugar: [TotalSugarPerMonthDomainModel],
                                            selectedDateComponents: DateComponents) -> [Double] {
        guard let selectedMonthTotalSugar = monthlyTotalSugar.last,
              let day = selectedDateComponents.day else { return [] }
        var dailySugarAverage = [Double]()
        let selectedWeekday = getSelectedDateComponentsWeekday(selectedDateComponents)
        let sundayIndex = day - selectedWeekday
        var resultCount = Int()
        if selectedDateComponentsIsCurrentWeek(selectedDateComponents) {
            resultCount = getSelectedDateComponentsWeekday(DateComponents.currentDateComponents())
        } else {
            resultCount = 7
        }
        for i in 0 ..< resultCount {
            var weekdaySugar: Double = 0
            if sundayIndex + i < 0 {
                let previousMonthTotalSugar = monthlyTotalSugar[monthlyTotalSugar.count - 2].totalSugarPerMonth
                let previousMonthindex = sundayIndex + i
                weekdaySugar = previousMonthTotalSugar[previousMonthTotalSugar.count + previousMonthindex].totalSugar
            } else {
                weekdaySugar = selectedMonthTotalSugar.totalSugarPerMonth[sundayIndex + i].totalSugar
            }
            dailySugarAverage.append(weekdaySugar)
        }
        return dailySugarAverage
    }
    
    private func selectedDateComponentsIsCurrentWeek(_ selectedDateComponents: DateComponents) -> Bool {
        let weekday = getSelectedDateComponentsWeekday(selectedDateComponents)
        let saturdayIndex = 7 - weekday
        var saturdayDateComponents: DateComponents = selectedDateComponents
        saturdayDateComponents.day = saturdayDateComponents.day! + saturdayIndex
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        guard let saturdayDate = calendar.date(from: saturdayDateComponents) else { return false }
        let currentDate = Date.currentDate()
        if currentDate < saturdayDate {
            return true
        } else {
            return false
        }
    }
    
    private func getSelectedDateComponentsWeekday(_ dateComponenets: DateComponents) -> Int {
        guard let year = dateComponenets.year,
              let month = dateComponenets.month,
              let day = dateComponenets.day else { return 0}
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar.component(.weekday, from: .makeDate(year: year, month: month, day: day))
    }
    
}
