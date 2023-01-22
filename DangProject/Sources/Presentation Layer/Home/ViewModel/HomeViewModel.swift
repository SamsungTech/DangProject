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

protocol CheckDataProtocol {
    func checkData()
}

protocol HomeViewModelInputProtocol {
    func fetchProfileData()
    func fetchCurrentMonthData(dateComponents: DateComponents)
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents)
    func fetchOnlyCalendar(_ dateComponents: DateComponents)
    func fetchSelectedEatenFoods(_ dateComponents: DateComponents)
    func fetchGraphData(from dateComponents: DateComponents)
    func changeCellIndexColumn(cellIndexColumn: Int)
    func plusViewsDataCount()
}

protocol HomeViewModelOutputProtocol {
    var calendarViewColumn: Int { get set }
    var profileDataRelay: BehaviorRelay<ProfileDomainModel> { get }
    var loading: PublishRelay<LoadingState> { get}
    func checkNavigationBarTitleText(dateComponents: DateComponents) -> String
    func getEatenFoodsTitleText(dateComponents: DateComponents) -> String
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private let disposeBag = DisposeBag()
    var calendarViewColumn: Int = 0
    
    // MARK: - Init
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let profileManagerUseCase: ProfileManagerUseCase
    private var isViewsInHome = 0
    var profileDataRelay = BehaviorRelay<ProfileDomainModel>(value: .empty)
    let loading = PublishRelay<LoadingState>()
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase,
         profileManagerUseCase: ProfileManagerUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
        self.profileManagerUseCase = profileManagerUseCase
        self.bindProfileData()
    }
    
    func fetchProfileData() {
        profileManagerUseCase.fetchProfileData()
    }
    
    func fetchCurrentMonthData(dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchCurrentMonthsData { isDone in
            if isDone == false {
                
            }
        }
    }
    
    func fetchSelectedEatenFoods(_ dateComponents: DateComponents) {
        let date: Date = .makeDate(year: dateComponents.year,
                                   month: dateComponents.month!,
                                   day: dateComponents.day)
        
        fetchEatenFoodsUseCase.fetchMonthsData(month: dateComponents) { isDone in
            if isDone == false {
                
            }
        }
        fetchEatenFoodsUseCase.fetchEatenFoods(date: date)
    }
    
    func fetchGraphData(from dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchSevenMonthsTotalSugar(from: dateComponents)
    }
    
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchMonthsData(month: dateComponents) { isDone in
            if isDone == false {
                
            }
        }
    }
    
    func fetchOnlyCalendar(_ dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchNextMonthData(month: dateComponents)
    }
    
    func changeCellIndexColumn(cellIndexColumn: Int) {
        self.calendarViewColumn = cellIndexColumn
    }
    
    func plusViewsDataCount() {
        isViewsInHome += 1
        if isViewsInHome == 3 {
            loading.accept(.finishLoading)
            isViewsInHome = 0
        }
    }
    
    func checkNavigationBarTitleText(dateComponents: DateComponents) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월"
        guard let unwrappedDate = Calendar.current.date(from: dateComponents) else { return "" }
        let dateToString = dateFormatter.string(from: unwrappedDate)
        return dateToString
    }
    
    func getEatenFoodsTitleText(dateComponents: DateComponents) -> String {
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
    
    private func bindProfileData() {
        profileManagerUseCase.profileDataObservable
            .subscribe(onNext: { [weak self] in
                self?.profileDataRelay.accept($0)
            })
            .disposed(by: disposeBag)
    }
}
