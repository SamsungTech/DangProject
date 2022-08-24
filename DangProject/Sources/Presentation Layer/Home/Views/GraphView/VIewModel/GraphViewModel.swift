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
                let nextMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 1]
                let currentMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 2]
                let previousMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 3]
                
                guard let monthlyAverage = self?.calculateMonthlySugarAverage(monthlyTotalSugar),
                      let weeklyAverage = self?.calculateWeeklySugarAverage(monthlyTotalSugar: monthlyTotalSugar, selectedDateComponents: dateComponents),
                      let dailyAverage = self?.calculateDailySugar(currentMonthTotalSugar: currentMonthData,
                                                                   previousMonthTotalSugar: previousMonthData,
                                                                   nextMonthTotalSugar: nextMonthData,
                                                                   selectedDateComponents: dateComponents) else { return }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func calculateWeeklySugarAverage(monthlyTotalSugar: [TotalSugarPerMonthDomainModel],
                                             selectedDateComponents: DateComponents) -> [Double] {
        
        var weeklySugarAverage = [Double]()
        var dateComponents = selectedDateComponents
        for _ in 0 ... 6 {
            let currentMonth: DateComponents = {
                var dc: DateComponents = .configureDateComponents(dateComponents)
                dc.day = 1
                return .configureDateComponents(dc)
            }()
            let previousMonth: DateComponents = {
                var dc: DateComponents = .configureDateComponents(dateComponents)
                dc.month = dc.month! - 1
                dc.day = 1
                return dc
            }()
            let nextMonth: DateComponents = {
                var dc: DateComponents = .configureDateComponents(dateComponents)
                dc.month = dc.month! + 1
                dc.day = 1
                return dc
            }()
            let currentMonthData = getMonthTotalSugarData(with: currentMonth,
                                                          from: monthlyTotalSugar)
            let previousMonthData = getMonthTotalSugarData(with: previousMonth,
                                                           from: monthlyTotalSugar)
            let nextMonthData = getMonthTotalSugarData(with: nextMonth,
                                                       from: monthlyTotalSugar)
            let weeklyData = calculateDailySugar(currentMonthTotalSugar: currentMonthData,
                                                 previousMonthTotalSugar: previousMonthData,
                                                 nextMonthTotalSugar: nextMonthData,
                                                 selectedDateComponents: .configureDateComponents(dateComponents))
            let weeklySugarAverageData = calculateWeeklyAverage(weeklyData: weeklyData)
            weeklySugarAverage.append(weeklySugarAverageData)
            dateComponents.day! = dateComponents.day! - 7
        }
        return weeklySugarAverage.reversed()
    }
    
    private func getMonthTotalSugarData(with dateComponents: DateComponents,
                                        from monthlyTotalSugar: [TotalSugarPerMonthDomainModel] ) -> TotalSugarPerMonthDomainModel {
        var result = TotalSugarPerMonthDomainModel.empty
        monthlyTotalSugar.forEach { monthlyData in
            if dateComponents == monthlyData.month {
                result = TotalSugarPerMonthDomainModel.init(month: monthlyData.month,
                                                            totalSugarPerMonth: monthlyData.totalSugarPerMonth)
            }
        }
        return result
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
                                     nextMonthTotalSugar: TotalSugarPerMonthDomainModel,
                                     selectedDateComponents: DateComponents) -> [Double] {
        
        guard let day = selectedDateComponents.day else { return [] }
        var dailySugar = [Double]()
        let selectedWeekday = getSelectedDateComponentsWeekday(selectedDateComponents)
        let sundayIndex = day - selectedWeekday
        
        var resultCount = Int()
        if selectedDateComponentsIsCurrentWeek(selectedDateComponents) {
            resultCount = getSelectedDateComponentsWeekday(DateComponents.currentDateComponents())
        } else {
            resultCount = 7
        }
        var nextMonthIndex: Int = 0
        for i in 0 ..< resultCount {
            var weekdaySugar: Double = 0
            
            if sundayIndex + i < 0 {
                let previousMonthTotalSugar = previousMonthTotalSugar.totalSugarPerMonth
                let previousMonthIndex = sundayIndex + i
                weekdaySugar = previousMonthTotalSugar[previousMonthTotalSugar.count + previousMonthIndex].totalSugar
            } else if sundayIndex + i >= currentMonthTotalSugar.totalSugarPerMonth.count {
                weekdaySugar = nextMonthTotalSugar.totalSugarPerMonth[nextMonthIndex].totalSugar
                nextMonthIndex += 1
            }  else {
                weekdaySugar = currentMonthTotalSugar.totalSugarPerMonth[sundayIndex + i].totalSugar
            }
            dailySugar.append(weekdaySugar)
        }
        return dailySugar
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
