//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import UIKit

import RxSwift
import RxRelay

enum PagingState {
    case left
    case right(Int)
    case empty
}

enum ScrollDirection {
    case right
    case center
    case left
}

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
    func viewDidLoad()
    func calculateCalendarScaleState()
    func calculateSelectedDayXPoint()
    func giveDirections(currentPoint: CGFloat)
    func calculateAfterSettingDirection()
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double)
    func resetBatteryViewMainCircleProgressBar()
}

protocol HomeViewModelOutputProtocol {
    var dangComprehensiveData: BehaviorRelay<DangComprehensive> { get }
    var batteryViewCalendarData: BehaviorRelay<[BatteryEntity]> { get }
    var reloadData: BehaviorRelay<Void> { get }
    var pagingState: BehaviorRelay<PagingState> { get }
    var scrollDirection: BehaviorRelay<ScrollDirection> { get }
    var currentXPoint: BehaviorRelay<Int> { get }
    var currentDateCGPoint: BehaviorRelay<CGPoint> { get }
    var currentLineYValue: BehaviorRelay<CGFloat> { get }
    var currentCount: BehaviorRelay<Int> { get }
    var currentYearMonth: BehaviorRelay<String> { get }
    var selectedCellViewData: BehaviorRelay<SelectedCellEntity> { get }
    var selectedCellData: BehaviorRelay<SelectedCalendarCellEntity> { get }
    var calendarScaleAnimation: BehaviorRelay<CalendarScaleState> { get }
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {
    var homeViewController: HomeViewControllerProtocol? { get set }
}

class HomeViewModel: HomeViewModelProtocol {
    private var homeUseCase: HomeUseCaseProtocol
    private var calendarService: CalendarService
    private var disposeBag = DisposeBag()
    private var currentPoint: CGFloat = 0
    
    var homeViewController: HomeViewControllerProtocol?
    var scrollDirection = BehaviorRelay<ScrollDirection>(value: .center)
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
    var selectedCellData = BehaviorRelay<SelectedCalendarCellEntity>(value: .empty)
    var batteryViewCalendarData = BehaviorRelay<[BatteryEntity]>(value: [])
    var pagingState = BehaviorRelay<PagingState>(value: .empty)
    var dangComprehensiveData = BehaviorRelay<DangComprehensive>(value: .empty)
    
    init(useCase: HomeUseCaseProtocol,
         calendarService: CalendarService) {
        self.homeUseCase = useCase
        self.calendarService = calendarService
    }
    
    func viewDidLoad() {
        calendarService.initCalculationDaysInMonth()
        homeUseCase.execute()
        bindSelectedCellData()
        bindCalendarViewData()
        bindHomeViewData()
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
        let count = batteryViewCalendarData.value.count
        
        for i in 0..<count {
            if batteryViewCalendarData.value[i].yearMonth == selectedCellData.value.yearMonth {
                let point = CGPoint(x: UIScreen.main.bounds.maxX*CGFloat(i), y: .zero)
                currentXPoint.accept(i)
                currentDateCGPoint.accept(point)
            } else {
                continue
            }
        }
    }
    
    func giveDirections(currentPoint: CGFloat) {
        self.currentPoint = currentPoint
        let count = batteryViewCalendarData.value.count
        let currentPoint = currentPoint
        
        if currentPoint <= 0 {
            scrollDirection.accept(.left)
        } else if currentPoint >= UIScreen.main.bounds.maxX * CGFloat(count-1) {
            scrollDirection.accept(.right)
        } else {
            scrollDirection.accept(.center)
        }
    }
    
    func calculateAfterSettingDirection() {
        let maxXValue = UIScreen.main.bounds.maxX
        let result = currentPoint / maxXValue
        
        switch scrollDirection.value {
        case .left:
            calendarService.createPreviousCalendarData()
            currentXPoint.accept(1)
        case .center:
            currentXPoint.accept(Int(result))
        case .right:
            calendarService.createNextCalendarData()
            let number = batteryViewCalendarData.value.count
            currentXPoint.accept(Int(number-2))
        }
    }
    
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double) {
        selectedCellViewData.accept(
            SelectedCellEntity(dang: selectedDangData,
                               maxDang: selectedMaxDangData)
        )
    }
    
    func resetBatteryViewMainCircleProgressBar() {
        homeViewController?.resetBatteryViewConfigure()
    }
}

extension HomeViewModel {
    private func bindCalendarViewData() {
        calendarService.calendarDataArraySubject
            .map { $0.map { BatteryEntity(calendar: $0)} }
            .subscribe(onNext: { [weak self] in
                guard let currentCount = self?.calendarService.currentDay.value else { return }
                self?.batteryViewCalendarData.accept($0)
                self?.selectedCellData.accept(
                    SelectedCalendarCellEntity(
                        yearMonth: $0[1].yearMonth,
                        indexPath: IndexPath(item: currentCount-1, section: 0)
                    )
                )
                self?.reloadData.accept(())
            })
            .disposed(by: disposeBag)
        
        calendarService.currentLine
            .map { .calculateRevertAnimationYValue(value: $0) }
            .subscribe(onNext: { [weak self] in
                self?.currentLineYValue.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarService.currentLine
            .subscribe(onNext: { [weak self] in
                self?.currentLine.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarService.currentDateYearMonth
            .subscribe(onNext: { [weak self] in
                self?.currentYearMonth.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarService.currentDay
            .map { $0-1 }
            .subscribe(onNext: { [weak self] in
                guard let currentDayDang = self?.batteryViewCalendarData.value[1].dangArray[$0],
                      let currentMaxDang = self?.batteryViewCalendarData.value[1].maxDangArray[$0] else { return }
                
                self?.currentCount.accept($0)
                self?.selectedCellViewData.accept(
                    SelectedCellEntity(dang: currentDayDang,
                                       maxDang: currentMaxDang)
                )
            })
            .disposed(by: disposeBag)
        
        calendarService.calendarPreviousMonthData
            .map {
                [BatteryEntity(calendar: $0)]+self.batteryViewCalendarData.value
            }
            .subscribe(onNext: { [weak self] in
                self?.batteryViewCalendarData.accept($0)
                self?.pagingState.accept(.left)
            })
            .disposed(by: disposeBag)
        
        calendarService.calendarNextMonthData
            .map {
                self.batteryViewCalendarData.value+[BatteryEntity(calendar: $0)]
            }
            .subscribe(onNext: { [weak self] in
                self?.batteryViewCalendarData.accept($0)
                guard let count = self?.batteryViewCalendarData.value.count else { return }
                self?.pagingState.accept(.right(count - 1))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHomeViewData() {
        homeUseCase.yearMonthWeekDangData
            .subscribe(onNext: { [weak self] in
                self?.dangComprehensiveData.accept(
                    DangComprehensive(yearMonthWeekDang: $0)
                )
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSelectedCellData() {
        selectedCellData
            .subscribe(onNext: { [weak self] in
                guard let indexPathItem = $0.indexPath?.item else { return }
                self?.calendarService.calculateCurrentLine(currentDay: indexPathItem)
            })
            .disposed(by: disposeBag)
    }
}