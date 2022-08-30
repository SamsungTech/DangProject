//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//
import UIKit
import Foundation

import RxSwift
import RxRelay

enum GraphSegmentedControlItem: Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
}

protocol GraphViewModelInputProtocol {
    func changeGraphView(to index: Int)
}

protocol GraphViewModelOutputProtocol {
    var weekdayString: [String] { get }
    var graphDataRelay: PublishRelay<[(String, CGFloat)]> { get }
    func configureGraphLabelFontSize(_ view: UIView, graphDataString: String) -> UIFont
    func configureGraphHeightConstant(_ view: UIView, sugarValue: CGFloat) -> CGFloat
}

protocol GraphViewModelProtocol: GraphViewModelInputProtocol, GraphViewModelOutputProtocol { }

class GraphViewModel: GraphViewModelProtocol {
      
    private let disposeBag = DisposeBag()
    var graphDataRelay = PublishRelay<[(String, CGFloat)]>()
    lazy var weekdayString = [ "일", "월", "화", "수", "목", "금", "토" ]
    private lazy var dailyGraphData: [(String, CGFloat)] = []
    private lazy var weeklyGraphData: [(String, CGFloat)] = []
    private lazy var monthlyGraphData: [(String, CGFloat)] = []
    private lazy var currentSegmentedState: GraphSegmentedControlItem = .daily
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        bindMonthlyTotalSugarObservable()
    }
    
    // MARK: - Input
    
    func changeGraphView(to index: Int) {
        guard currentSegmentedState.rawValue != index else { return }

        switch index {
        case GraphSegmentedControlItem.daily.rawValue:
            currentSegmentedState = .daily
            graphDataRelay.accept(dailyGraphData)
            
        case GraphSegmentedControlItem.weekly.rawValue:
            currentSegmentedState = .weekly
            graphDataRelay.accept(weeklyGraphData)
            
        case GraphSegmentedControlItem.monthly.rawValue:
            currentSegmentedState = .monthly
            graphDataRelay.accept(monthlyGraphData)
            
        default:
            break
        }
        
    }
    
    //MARK: - Output
    
    private func bindMonthlyTotalSugarObservable() {
        fetchEatenFoodsUseCase.sevenMonthsTotalSugarObservable
            .subscribe(onNext: { [weak self] selectedDateComponents, monthlyTotalSugar in
                let nextMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 1]
                let currentMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 2]
                let previousMonthData = monthlyTotalSugar[monthlyTotalSugar.count - 3]
                
                guard let monthlyAverage = self?.calculateMonthlySugarAverage(monthlyTotalSugar),
                      let weeklyAverage = self?.calculateWeeklySugarAverage(monthlyTotalSugar: monthlyTotalSugar, selectedDateComponents: selectedDateComponents),
                      let dailyAverage = self?.calculateDailySugar(currentMonthTotalSugar: currentMonthData,
                                                                   previousMonthTotalSugar: previousMonthData,
                                                                   nextMonthTotalSugar: nextMonthData,
                                                                   selectedDateComponents: selectedDateComponents),
                      let dailyData = self?.configureDailyGraphData(dailyAverage: dailyAverage),
                      let weeklyData = self?.configureWeeklyGraphData(selectedDateComponents: selectedDateComponents,
                                                                      weeklyAverage: weeklyAverage),
                      let monthlyData = self?.configureMonthlyGraphData(graphData: monthlyTotalSugar,
                                                                        monthlyAverage: monthlyAverage) else { return }
            
                self?.monthlyGraphData = monthlyData
                self?.dailyGraphData = dailyData
                self?.weeklyGraphData = weeklyData
                
                switch self?.currentSegmentedState {
                case .daily:
                    self?.graphDataRelay.accept(dailyData)
                case .weekly:
                    self?.graphDataRelay.accept(weeklyData)
                case .monthly:
                    self?.graphDataRelay.accept(monthlyData)
                case .none:
                    break
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    private func configureWeeklyGraphData(selectedDateComponents: DateComponents,
                                          weeklyAverage: [Double]) -> [(String, CGFloat)] {
        var weeklyData = [(String, CGFloat)]()
        let weeklyString = getWeeklyString(selectedDateComponents)
        for i in 0 ..< weeklyString.count {
            weeklyData.append((weeklyString[i], weeklyAverage[i]))
        }
        return weeklyData
    }
    
    private func configureDailyGraphData(dailyAverage: [Double]) -> [(String, CGFloat)] {
        var dailyData = [(String, CGFloat)]()
        for i in 0 ..< weekdayString.count {
            if i < dailyAverage.count {
                dailyData.append((weekdayString[i], dailyAverage[i]))
            } else {
                dailyData.append((weekdayString[i], 0))
            }
        }
        return dailyData
    }
    
    private func configureMonthlyGraphData(graphData: [TotalSugarPerMonthDomainModel],
                                           monthlyAverage: [Double]) -> [(String, CGFloat)] {
        var monthlyData = [(String, CGFloat)]()
        let monthlyString = getMonthlyString(graphData)
        for i in 0 ..< monthlyString.count {
            monthlyData.append((monthlyString[i], monthlyAverage[i]))
        }
        return monthlyData
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
                var dc = currentMonth
                dc.month = dc.month! - 1
                return .configureDateComponents(dc)
            }()
            
            let nextMonth: DateComponents = {
                var dc = currentMonth
                dc.month = dc.month! + 1
                return .configureDateComponents(dc)
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
    
    private func getMonthlyString(_ monthlyTotalSugar: [TotalSugarPerMonthDomainModel]) -> [String] {
        var result = [String]()
        for i in 0 ..< monthlyTotalSugar.count-1 {
            guard let year = monthlyTotalSugar[i].month.year,
                  let month = monthlyTotalSugar[i].month.month else { return [] }
            if monthlyTotalSugar[i].month.month == 1 {
                result.append("\(year)\n\(month)월")
            } else {
                result.append("\(month)월")
            }
        }
        return result
    }
    
    private func getWeeklyString(_ selectedDateComponents: DateComponents) -> [String] {
        var result = [String]()
        var dateComponents = selectedDateComponents
        for _ in 0 ..< 7 {
            let weekday = getSelectedDateComponentsWeekday(dateComponents)
            let thursdayIndex = 5 - weekday
            var thursDateComponents: DateComponents = dateComponents
            thursDateComponents.day = thursDateComponents.day! + thursdayIndex
            let configuredDateComponents = DateComponents.configureDateComponents(thursDateComponents)
            dateComponents.day = dateComponents.day! - 7
            guard let month = configuredDateComponents.month,
                  let day = configuredDateComponents.day else { return [] }
            let weekNumber = (day / 7) + 1
            result.append("\(month)월\n\(weekNumber)주차")
        }
        return result.reversed()
    }
    
    func configureGraphLabelFontSize(_ view: UIView, graphDataString: String) -> UIFont {
        if graphDataString.count < 2 {
            return UIFont.boldSystemFont(ofSize: view.xValueRatio(15))
        } else if graphDataString.count > 3 {
            return UIFont.boldSystemFont(ofSize: view.xValueRatio(10))
        } else {
            return UIFont.boldSystemFont(ofSize: view.xValueRatio(13))
        }
    }
    
    func configureGraphHeightConstant(_ view: UIView, sugarValue: CGFloat) -> CGFloat {
        return min(view.yValueRatio(sugarValue * 2), view.yValueRatio(180))
    }
}
