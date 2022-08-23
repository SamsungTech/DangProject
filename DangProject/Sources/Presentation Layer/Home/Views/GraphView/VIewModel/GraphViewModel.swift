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
                let currentMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 1]
                let previousMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 2]
                
                let monthlyAverage = self?.calculateMonthlySugarAverage(monthlyTotalSugar)
                let dailyAverage = self?.calculateDailySugar(currentMonthTotalSugar: currentMonthData,
                                                             previousMonthTotalSugar: previousMonthData,
                                                             selectedDateComponents: dateComponents)
                let weeklyAverage = self?.calculateWeeklySugarAverage(monthlyTotalSugar: monthlyTotalSugar, selectedDateComponents: dateComponents)
            })
            .disposed(by: disposeBag)
    }
    
    private func calculateWeeklySugarAverage(monthlyTotalSugar: [TotalSugarPerMonthDomainModel],
                                             selectedDateComponents: DateComponents) -> [Double] {
        let currentMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 1]
        let previousMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 2]
        
        var weeklySugarAverage = [Double]()
        var dateComponents = selectedDateComponents
        for _ in 0 ... 6 {
            dateComponents.day! = dateComponents.day! - 7
            let weeklyData = calculateDailySugar(currentMonthTotalSugar: currentMonthData,
                                                  previousMonthTotalSugar: previousMonthData,
                                                  selectedDateComponents: dateComponents)
            let weeklySugarAverageData = calculateWeeklyAverage(weeklyData: weeklyData)
            weeklySugarAverage.append(weeklySugarAverageData)
        }
        // 이전 3달치가 필요한 경우 터짐 -> calculateDailSugar 메서드를 현재, 이전달만 받아 사용하도록 수정하고 - 완료
        //        3달치가 필요할 경우를 분기처리해서 이때는 전달, 전전달 을 전달해야함
        print(weeklySugarAverage)
        return weeklySugarAverage
    }
    
    private func calculateWeeklyAverage(weeklyData: [Double]) -> Double {
        var totalSugar: Double = 0
        weeklyData.forEach {
            totalSugar = totalSugar + $0
        }
        return (totalSugar / Double(weeklyData.count)).roundDecimal(to: 1)
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
    
    private func calculateDailySugar(currentMonthTotalSugar: TotalSugarPerMonthDomainModel,
                                      previousMonthTotalSugar: TotalSugarPerMonthDomainModel,
                                      selectedDateComponents: DateComponents) -> [Double] {
        guard let day = selectedDateComponents.day else { return [] }
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
                let previousMonthTotalSugar = previousMonthTotalSugar.totalSugarPerMonth
                let previousMonthindex = sundayIndex + i
                weekdaySugar = previousMonthTotalSugar[previousMonthTotalSugar.count + previousMonthindex].totalSugar
            } else {
                weekdaySugar = currentMonthTotalSugar.totalSugarPerMonth[sundayIndex + i].totalSugar
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
