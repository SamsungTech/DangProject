//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

import RxSwift
import RxRelay

enum CalendarScaleState {
    case expand
    case revert
}
protocol HomeViewModelInputProtocol {
    func fetchCurrentMonthData(dateComponents: DateComponents)
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents)
    func fetchOnlyCalendar(_ dateComponents: DateComponents)
    func changeCellIndexColumn(cellIndexColumn: Int)
}

protocol HomeViewModelOutputProtocol {
    var calendarViewColumn: Int { get set }
    func checkNavigationBarTitleText(dateComponents: DateComponents) -> String
    func checkEatenFoodsTitleText(dateComponents: DateComponents) -> String
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    var calendarViewColumn: Int = 0
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
    }
    
    func fetchCurrentMonthData(dateComponents: DateComponents) {
        let date: Date = .makeDate(year: dateComponents.year,
                                   month: dateComponents.month!,
                                   day: dateComponents.day)
        fetchEatenFoodsUseCase.fetchEatenFoods(date: date)
        fetchEatenFoodsUseCase.fetchCurrentMonthsData()
    }
    
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchMonthsData(month: dateComponents)
    }
    
    func fetchOnlyCalendar(_ dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchNextMonthData(month: dateComponents)
    }
    
    func changeCellIndexColumn(cellIndexColumn: Int) {
        self.calendarViewColumn = cellIndexColumn
    }
    
    func checkNavigationBarTitleText(dateComponents: DateComponents) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        guard let unwrappedDate = Calendar.current.date(from: dateComponents) else { return "" }
        let dateToString = dateFormatter.string(from: unwrappedDate)
        return dateToString
    }
    
    func checkEatenFoodsTitleText(dateComponents: DateComponents) -> String {
        let todayDateComponents = DateComponents.currentDateComponents()
        let yesterdayDateComponents: DateComponents = {
            var today = DateComponents.currentDateComponents()
            today.day! = today.day! - 1
            return today
        }()
        if dateComponents == todayDateComponents {
            return "🍲 오늘 먹은것들"
        } else if dateComponents == yesterdayDateComponents {
            return "🍲 어제 먹은것들"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "🍲 M월 dd일에 먹은것들"
            guard let unwrappedDate = Calendar.current.date(from: dateComponents) else { return "" }
            let dateToString = dateFormatter.string(from: unwrappedDate)

            return dateToString
        }
    }
    
}
