//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

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

struct SelectedCellEntity {
    static let empty: Self = .init(selectedCircleColor: UIColor.clear.cgColor,
                                   selectedCircleBackgroundColor: UIColor.clear.cgColor,
                                   selectedDangValue: "",
                                   selectedMaxDangValue: "",
                                   circleDangValue: 0,
                                   circlePercentValue: 0,
                                   circleAnimationDuration: 0.0,
                                   selectedAnimationLineColor: UIColor.clear.cgColor)
    
    var selectedCircleColor: CGColor
    var selectedCircleBackgroundColor: CGColor
    var selectedDangValue: String
    var selectedMaxDangValue: String
    var circleDangValue: CGFloat
    var circlePercentValue: Int
    var circleAnimationDuration: Double
    var selectedAnimationLineColor: CGColor
    
    init(selectedCircleColor: CGColor,
         selectedCircleBackgroundColor: CGColor,
         selectedDangValue: String,
         selectedMaxDangValue: String,
         circleDangValue: CGFloat,
         circlePercentValue: Int,
         circleAnimationDuration: Double,
         selectedAnimationLineColor: CGColor) {
        self.selectedCircleColor = selectedCircleColor
        self.selectedCircleBackgroundColor = selectedCircleBackgroundColor
        self.selectedDangValue = selectedDangValue
        self.selectedMaxDangValue = selectedMaxDangValue
        self.circleDangValue = circleDangValue
        self.circlePercentValue = circlePercentValue
        self.circleAnimationDuration = circleAnimationDuration
        self.selectedAnimationLineColor = selectedAnimationLineColor
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
    var tempData: BehaviorRelay<[tempNutrient]> { get }
    var weekData: BehaviorRelay<[weekTemp]> { get }
    var monthData: BehaviorRelay<CalendarMonthDangEntity> { get }
    var yearData: BehaviorRelay<[tempNutrient]> { get }
    var sumData: BehaviorRelay<sugarSum> { get }
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

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var homeUseCase: HomeUseCase
    private var calendarUseCase: CalendarUseCase
    private var disposeBag = DisposeBag()
    private var currentPoint: CGFloat = 0
    var homeViewController: HomeViewControllerProtocol?
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    var weekData = BehaviorRelay<[weekTemp]>(value: [])
    var monthData = BehaviorRelay<CalendarMonthDangEntity>(value: .empty)
    var yearData = BehaviorRelay<[tempNutrient]>(value: [])
    var sumData = BehaviorRelay<sugarSum>(value: .empty)
    var batteryViewCalendarData = BehaviorRelay<[BatteryEntity]>(value: [])
    var reloadData = BehaviorRelay<Void>(value: ())
    var pagingState = BehaviorRelay<PagingState>(value: .empty)
    var scrollDirection = BehaviorRelay<ScrollDirection>(value: .center)
    var currentXPoint = BehaviorRelay<Int>(value: 1)
    var currentDateCGPoint = BehaviorRelay<CGPoint>(value: CGPoint())
    var currentLineYValue = BehaviorRelay<CGFloat>(value: 0)
    var currentLine = BehaviorRelay<Int>(value: 0)
    var currentCount = BehaviorRelay<Int>(value: 0)
    var currentYearMonth = BehaviorRelay<String>(value: "")
    var selectedCellViewData = BehaviorRelay<SelectedCellEntity>(value: .empty)
    var selectedCellData = BehaviorRelay<SelectedCalendarCellEntity>(value: .empty)
    var calendarScaleAnimation = BehaviorRelay<CalendarScaleState>(value: .revert)
    
    init(useCase: HomeUseCase,
         calendarUseCase: CalendarUseCase) {
        self.homeUseCase = useCase
        self.calendarUseCase = calendarUseCase
    }
}

extension HomeViewModel {
    func viewDidLoad() {
        retrieveBatteryCalendarViewData()
        retrieveHomeViewData()
        retrieveSelectedCellData()
    }
    
    private func retrieveBatteryCalendarViewData() {
        calendarUseCase.initCalculationDaysInMonth()
        
        calendarUseCase.calendarDataArraySubject
            .map { $0.map { BatteryEntity(calendar: $0)} }
            .subscribe(onNext: { [weak self] in
                guard let yearMonth = $0[1].yearMonth,
                      let currentCount = self?.calendarUseCase.currentDay.value else { return }
                self?.batteryViewCalendarData.accept($0)
                self?.selectedCellData.accept(SelectedCalendarCellEntity(yearMonth: yearMonth,
                                                                         indexPath: IndexPath(item: currentCount-1, section: 0)))
                self?.reloadData.accept(())
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentLine
            .map { .calculateRevertAnimationYValue(value: $0) }
            .subscribe(onNext: { [weak self] in
                self?.currentLineYValue.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentLine
            .subscribe(onNext: { [weak self] in
                self?.currentLine.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentDateYearMonth
            .subscribe(onNext: { [weak self] in
                self?.currentYearMonth.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentDay
            .map { $0-1 }
            .subscribe(onNext: { [weak self] in
                guard let currentDayDang = self?.batteryViewCalendarData.value[1].dangArray?[$0],
                      let currentMaxDang = self?.batteryViewCalendarData.value[1].maxDangArray?[$0] else { return }
                let circleColor: CGColor = .calculateCircleProgressBarColor(dang: currentDayDang,
                                                                            maxDang: currentMaxDang)
                let circleBackgroundColor: CGColor = .calculateCircleProgressBackgroundColor(dang: currentDayDang,
                                                                                             maxDang: currentMaxDang)
                let dangValue = String(currentDayDang)
                let maxDangValue = String(currentMaxDang)
                let circleDangValue: CGFloat = .calculateMonthDangDataNumber(dang: currentDayDang, maxDang: currentMaxDang)
                let circlePercentValue: Int = .calculatePercentValue(dang: currentDayDang, maxDang: currentMaxDang)
                let circleAnimationDuration: Double = .calculateCircleAnimationDuration(dang: currentDayDang, maxDang: currentMaxDang)
                let selectedAnimationLineColor: CGColor = .calculateCirclePercentLineColor(dang: currentDayDang, maxDang: currentMaxDang)
                
                self?.currentCount.accept($0)
                self?.selectedCellViewData.accept(SelectedCellEntity(selectedCircleColor: circleColor,
                                                                     selectedCircleBackgroundColor: circleBackgroundColor,
                                                                     selectedDangValue: dangValue,
                                                                     selectedMaxDangValue: maxDangValue,
                                                                     circleDangValue: circleDangValue,
                                                                     circlePercentValue: circlePercentValue,
                                                                     circleAnimationDuration: circleAnimationDuration,
                                                                     selectedAnimationLineColor: selectedAnimationLineColor))
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.calendarPreviousMonthData
            .map {
                [BatteryEntity(calendar: $0)]+self.batteryViewCalendarData.value
            }
            .subscribe(onNext: { [weak self] in
                self?.batteryViewCalendarData.accept($0)
                self?.pagingState.accept(.left)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.calendarNextMonthData
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
    
    private func retrieveHomeViewData() {
        homeUseCase.execute()
            .subscribe(onNext: { [weak self] in
                self?.tempData.accept($0)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveWeekData()
            .map { $0.map { weekTemp(tempNutrient: $0) } }
            .subscribe(onNext: { [weak self] in
                self?.weekData.accept($0)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveYearData()
            .subscribe(onNext: { [weak self] in
                self?.yearData.accept($0)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.calculateSugarSum()
            .subscribe(onNext: { [weak self] in
                self?.sumData.accept($0)
            })
            .disposed(by: disposeBag)
        
        homeUseCase.retriveMouthData()
            .map { CalendarMonthDangEntity(calendarMonthDang: $0) }
            .subscribe(onNext: { [weak self] in
                self?.monthData.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func retrieveSelectedCellData() {
        selectedCellData
            .subscribe(onNext: { [weak self] in
                guard let indexPathItem = $0.indexPath?.item else { return }
                self?.calendarUseCase.calculateCurrentLine(currentDay: indexPathItem)
            })
            .disposed(by: disposeBag)
    }
    
    private func scrolledCalendarToLeft() {
        calendarUseCase.createPreviousCalendarData()
    }
    
    private func scrolledCalendarToRight() {
        calendarUseCase.createNextCalendarData()
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
            scrolledCalendarToLeft()
            currentXPoint.accept(1)
        case .center:
            currentXPoint.accept(Int(result))
        case .right:
            scrolledCalendarToRight()
            let number = batteryViewCalendarData.value.count
            currentXPoint.accept(Int(number-2))
        }
    }
    
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double) {
        let circleColor: CGColor = .calculateCircleProgressBarColor(dang: selectedDangData,
                                                                    maxDang: selectedMaxDangData)
        let circleBackgroundColor: CGColor = .calculateCircleProgressBackgroundColor(dang: selectedDangData,
                                                                                     maxDang: selectedMaxDangData)
        let dangValue = String(selectedDangData)
        let maxDangValue = String(selectedMaxDangData)
        let circleDangValue: CGFloat = .calculateMonthDangDataNumber(dang: selectedDangData, maxDang: selectedMaxDangData)
        let circlePercentValue: Int = .calculatePercentValue(dang: selectedDangData, maxDang: selectedMaxDangData)
        let circleAnimationDuration: Double = .calculateCircleAnimationDuration(dang: selectedDangData, maxDang: selectedMaxDangData)
        let selectedAnimationLineColor: CGColor = .calculateCirclePercentLineColor(dang: selectedDangData, maxDang: selectedMaxDangData)
        
        selectedCellViewData.accept(SelectedCellEntity(selectedCircleColor: circleColor,
                                                       selectedCircleBackgroundColor: circleBackgroundColor,
                                                       selectedDangValue: dangValue,
                                                       selectedMaxDangValue: maxDangValue,
                                                       circleDangValue: circleDangValue,
                                                       circlePercentValue: circlePercentValue,
                                                       circleAnimationDuration: circleAnimationDuration,
                                                       selectedAnimationLineColor: selectedAnimationLineColor))
    }
    
    func resetBatteryViewMainCircleProgressBar() {
        homeViewController?.resetBatteryViewConfigure()
    }
}

