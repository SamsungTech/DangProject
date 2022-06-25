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

struct SelectedCellEntity: Equatable {
    static let empty: Self = .init(dang: 1.1, maxDang: 1.1)
    var selectedCircleColor: CGColor
    var selectedCircleBackgroundColor: CGColor
    var selectedDangValue: String
    var selectedMaxDangValue: String
    var circleDangValue: CGFloat
    var circlePercentValue: Int
    var circleAnimationDuration: Double
    var selectedAnimationLineColor: CGColor
}

extension SelectedCellEntity {
    init(dang: Double,
         maxDang: Double) {
        let selectedCircleColor: CGColor = .calculateCircleProgressBarColor(dang: dang, maxDang: maxDang)
        let selectedCircleBackgroundColor: CGColor = .calculateCircleProgressBackgroundColor(dang: dang, maxDang: maxDang)
        let circleDangValue: CGFloat = .calculateMonthDangDataNumber(dang: dang, maxDang: maxDang)
        let circlePercentValue: Int = .calculatePercentValue(dang: dang, maxDang: maxDang)
        let circleAnimationDuration: Double = .calculateCircleAnimationDuration(dang: dang, maxDang: maxDang)
        let selectedAnimationLineColor: CGColor = .calculateCirclePercentLineColor(dang: dang, maxDang: maxDang)
        self.selectedCircleColor = selectedCircleColor
        self.selectedCircleBackgroundColor = selectedCircleBackgroundColor
        self.selectedDangValue = String(dang)
        self.selectedMaxDangValue = String(maxDang)
        self.circleDangValue = circleDangValue
        self.circlePercentValue = circlePercentValue
        self.circleAnimationDuration = circleAnimationDuration
        self.selectedAnimationLineColor = selectedAnimationLineColor
    }
}

struct DangComprehensive: Equatable {
    static let empty: Self = .init(yearMonthWeekDang: .empty)
    var tempDang: [String]?
    var tempFoodName: [String]?
    var weekDang: [String]?
    var monthDang: [Double]?
    var monthMaxDang: [Double]?
    var yearDang: [String]?
    var todaySugarSum: String?
}

extension DangComprehensive {
    init(yearMonthWeekDang: YearMonthWeekDang) {
        self.tempDang = yearMonthWeekDang.tempDang
        self.tempFoodName = yearMonthWeekDang.tempFoodName
        self.weekDang = yearMonthWeekDang.weekDang
        self.monthDang = yearMonthWeekDang.monthDang
        self.monthMaxDang = yearMonthWeekDang.monthMaxDang
        self.yearDang = yearMonthWeekDang.yearDang
        self.todaySugarSum = doubleToString(double: yearMonthWeekDang.todaySugarSum ?? 0.0)
    }
    
    private func doubleToString(double: Double) -> String {
        return String(double)
    }
    
    private func doubleArrayToStringArray(doubleArray: [Double]) -> [String] {
        var resultArray: [String] = []
        
        for d in doubleArray {
            let result = String(d)
            resultArray.append(result)
        }
        
        return resultArray
    }
}

protocol HomeViewModelInputProtocol {
    func calculateCalendarScaleState()
    func calculateSelectedDayXPoint()
    func giveDirections(currentPoint: CGFloat)
    func calculateAfterSettingDirection()
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double)
    func resetBatteryViewMainCircleProgressBar()
    func refreshHomeViewController()
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents)
}

protocol HomeViewModelOutputProtocol {
    var dangComprehensiveData: BehaviorRelay<DangComprehensive> { get }
    var reloadData: BehaviorRelay<Void> { get }
    var currentXPoint: BehaviorRelay<Int> { get }
    var currentDateCGPoint: BehaviorRelay<CGPoint> { get }
    var currentLineYValue: BehaviorRelay<CGFloat> { get }
    var currentCount: BehaviorRelay<Int> { get }
    var currentYearMonth: BehaviorRelay<String> { get }
    var selectedCellViewData: BehaviorRelay<SelectedCellEntity> { get }
    var calendarScaleAnimation: BehaviorRelay<CalendarScaleState> { get }
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    private let disposeBag = DisposeBag()
    private var currentPoint: CGFloat = 0
    
//    var homeViewController: HomeViewControllerProtocol?
    var currentXPoint = BehaviorRelay<Int>(value: 1)
    var currentDateCGPoint = BehaviorRelay<CGPoint>(value: CGPoint())
    var currentCount = BehaviorRelay<Int>(value: 0)
    var calendarScaleAnimation = BehaviorRelay<CalendarScaleState>(value: .revert)
    // MARK: ViewDidLoad 에서 이벤트 받게되는 Subjects
    // MARK: 초기값 타이밍 이슈 있음
    var selectedCellViewData = BehaviorRelay<SelectedCellEntity>(value: .empty)
    var currentYearMonth = BehaviorRelay<String>(value: "")
    var currentLine = BehaviorRelay<Int>(value: 0)
    var currentLineYValue = BehaviorRelay<CGFloat>(value: 0)
    var reloadData = BehaviorRelay<Void>(value: ())
    var dangComprehensiveData = BehaviorRelay<DangComprehensive>(value: .empty)
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
    }
    
    func refreshHomeViewController() {
        let today = Date.currentDate()
        fetchEatenFoodsUseCase.fetchEatenFoods(date: today)
        fetchEatenFoodsUseCase.fetchTotalMonthsData(dateComponents: DateComponents.currentDateTimeComponents())
    }
    
    func fetchEatenFoodsInTotalMonths(_ dateComponents: DateComponents) {
        fetchEatenFoodsUseCase.fetchTotalMonthsData(dateComponents: dateComponents)
    }

    
    func calculateCalendarScaleState() {
        switch calendarScaleAnimation.value {
        case .expand:
            calendarScaleAnimation.accept(.revert)
        case .revert:
            calendarScaleAnimation.accept(.expand)
        }
    }
    
    func calculateSelectedDayXPoint() {
//        let count = batteryViewCalendarData.value.count
//
//        for i in 0..<count {
//            if batteryViewCalendarData.value[i].yearMonth == selectedCellData.value.yearMonth {
//                let point = CGPoint(x: UIScreen.main.bounds.maxX*CGFloat(i), y: .zero)
//                currentXPoint.accept(i)
//                currentDateCGPoint.accept(point)
//            } else {
//                continue
//            }
//        }
    }
    
    func giveDirections(currentPoint: CGFloat) {
//        self.currentPoint = currentPoint
//        let count = batteryViewCalendarData.value.count
//        let currentPoint = currentPoint
//
//        if currentPoint <= 0 {
//            scrollDirection.accept(.left)
//        } else if currentPoint >= UIScreen.main.bounds.maxX * CGFloat(count-1) {
//            scrollDirection.accept(.right)
//        } else {
//            scrollDirection.accept(.center)
//        }
    }
    
    func calculateAfterSettingDirection() {
//        let maxXValue = UIScreen.main.bounds.maxX
//        let result = currentPoint / maxXValue
//
//        switch scrollDirection.value {
//        case .left:
//            calendarService.createPreviousCalendarData()
//            currentXPoint.accept(1)
//        case .center:
//            currentXPoint.accept(Int(result))
//        case .right:
//            calendarService.createNextCalendarData()
//            let number = batteryViewCalendarData.value.count
//            currentXPoint.accept(Int(number-2))
//        }
    }
    
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double) {
        selectedCellViewData.accept(
            SelectedCellEntity(dang: selectedDangData,
                               maxDang: selectedMaxDangData)
        )
    }
    
    func resetBatteryViewMainCircleProgressBar() {
//        homeViewController?.resetBatteryViewConfigure()
    }
}
