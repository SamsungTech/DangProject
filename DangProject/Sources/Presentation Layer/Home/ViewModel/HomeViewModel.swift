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
    func fetchProfileData()
    func fetchGraphData()
    func fetchCurrentMonthData(dateComponents: DateComponents)
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents)
    func fetchOnlyCalendar(_ dateComponents: DateComponents)
    func fetchSelectedEatenFoods(_ dateComponents: DateComponents)
    func changeCellIndexColumn(cellIndexColumn: Int)
}

protocol HomeViewModelOutputProtocol {
    var calendarViewColumn: Int { get set }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
    func checkNavigationBarTitleText(dateComponents: DateComponents) -> String
    func checkEatenFoodsTitleText(dateComponents: DateComponents) -> String
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    var calendarViewColumn: Int = 0
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let fetchProfileUseCase: FetchProfileUseCase
    private let fetchGraphUseCase: FetchGraphDataUseCase
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         fetchProfileUseCase: FetchProfileUseCase,
         fetchGraphUseCase: FetchGraphDataUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.fetchProfileUseCase = fetchProfileUseCase
        self.fetchGraphUseCase = fetchGraphUseCase
    }
    
    func fetchProfileData() {
        fetchProfileUseCase.fetchProfileData()
            .subscribe(onNext: { [weak self] in
                self?.profileDataRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func fetchGraphData() {
        fetchGraphUseCase.createGraphThisYearMonthDayData()
    }
    
    func fetchCurrentMonthData(dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchCurrentMonthsData()
    }
    
    func fetchSelectedEatenFoods(_ dateComponents: DateComponents) {
        let date: Date = .makeDate(year: dateComponents.year,
                                   month: dateComponents.month!,
                                   day: dateComponents.day)
        
        fetchEatenFoodsUseCase.fetchMonthsData(month: dateComponents)
        fetchEatenFoodsUseCase.fetchEatenFoods(date: date)
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
            dateFormatter.dateFormat = "🍲 M월 d일에 먹은것들"
            guard let unwrappedDate = Calendar.current.date(from: dateComponents) else { return "" }
            let dateToString = dateFormatter.string(from: unwrappedDate)

            return dateToString
        }
    }
    
}
