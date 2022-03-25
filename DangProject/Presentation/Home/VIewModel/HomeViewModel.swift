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

protocol HomeViewModelInputProtocol {
    func viewDidLoad()
    func scrolledCalendarToLeft()
    func scrolledCalendarToRight()
}

protocol HomeViewModelOutputProtocol {
    var tempData: BehaviorRelay<[tempNutrient]> { get }
    var weekData: BehaviorRelay<[weekTemp]> { get }
    var monthData: BehaviorRelay<CalendarMonthDangEntity> { get }
    var yearData: BehaviorRelay<[tempNutrient]> { get }
    var sumData: BehaviorRelay<sugarSum> { get }
    var currentXPoint: BehaviorRelay<Int> { get }
    var currentDateCGPoint: BehaviorRelay<CGPoint> { get }
    var batteryViewCalendarData: BehaviorRelay<[BatteryEntity]> { get }
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

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

class HomeViewModel: HomeViewModelProtocol {
    private var homeUseCase: HomeUseCase
    private var calendarUseCase: CalendarUseCase
    var homeViewController: HomeViewControllerProtocol?
    private var disposeBag = DisposeBag()
    var currentPoint = BehaviorRelay<CGFloat>(value: CGFloat())
    var batteryViewCalendarData = BehaviorRelay<[BatteryEntity]>(value: [])
    var reloadData = BehaviorRelay<Void>(value: ())
    var pagingState = BehaviorRelay<PagingState>(value: .empty)
    var scrollDirection = BehaviorRelay<ScrollDirection>(value: .center)
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    var weekData = BehaviorRelay<[weekTemp]>(value: [])
    var monthData = BehaviorRelay<CalendarMonthDangEntity>(value: .empty)
    var yearData = BehaviorRelay<[tempNutrient]>(value: [])
    var sumData = BehaviorRelay<sugarSum>(value: .empty)
    var currentXPoint = BehaviorRelay<Int>(value: 1)
    var currentDateCGPoint = BehaviorRelay<CGPoint>(value: CGPoint())
    var currentLineYValue = BehaviorRelay<CGFloat>(value: 0)
    var currentCount = BehaviorRelay<Int>(value: 0)
    var currentYearMonth = BehaviorRelay<String>(value: "")
    var circleColor: [CGColor] = []
    var circleNumber: [CGFloat] = []
    var circleDangValue = BehaviorRelay<CGFloat>(value: 0)
    var circlePercentValue = BehaviorRelay<Int>(value: 0)

    var currentDangValue = BehaviorRelay<Double>(value: 0.0)
    var currentMaxDangValue = BehaviorRelay<Double>(value: 0.0)
    var circleAnimationDuration = BehaviorRelay<Double>(value: 0.0)
    
    var selectedDangValue = BehaviorRelay<String>(value: "")
    var selectedMaxDangValue = BehaviorRelay<String>(value: "")
    var selectedYearMonth = BehaviorRelay<String>(value: "")
    var selectedCircleColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var selectedCircleBackgroundColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var selectedAnimationLineColor = BehaviorRelay<CGColor>(value: UIColor.clear.cgColor)
    var selectedCellData = BehaviorRelay<SelectedCalendarCellEntity>(value: .empty)
    
    init(useCase: HomeUseCase,
         calendarUseCase: CalendarUseCase) {
        self.homeUseCase = useCase
        self.calendarUseCase = calendarUseCase
    }
}

extension HomeViewModel {
    func viewDidLoad() {
        calendarUseCase.initCalculationDaysInMouth()
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
            .map { self.calculateRevertAnimationYValue(value: $0) }
            .subscribe(onNext: { [weak self] in
                self?.currentLineYValue.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentDateYearMonth
            .subscribe(onNext: { [weak self] in
                self?.currentYearMonth.accept($0)
            })
            .disposed(by: disposeBag)
        
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
        
        calendarUseCase.currentDay
            .map { $0-1 }
            .subscribe(onNext: { [weak self] in
                guard let currentDayDang = self?.batteryViewCalendarData.value[1].dangArray?[$0],
                      let currentMaxDang = self?.batteryViewCalendarData.value[1].maxDangArray?[$0],
                      let circleDangValue = self?.calculateMonthDangDataNumber(dang: currentDayDang,
                                                                               maxDang: currentMaxDang),
                      let circlePercentValue = self?.calculatePercentValue(dang: currentDayDang,
                                                                           maxDang: currentMaxDang),
                      let circleColor = self?.calculateCircleProgressBarColor(dang: currentDayDang,
                                                                              maxDang: currentMaxDang),
                      let circleBackgroundColor = self?.calculateCircleProgressBackgroundColor(dang: currentDayDang,
                                                                                               maxDang: currentMaxDang),
                      let animationLineColor = self?.calculateCirclePercentLineColor(dang: currentDayDang,
                                                                                     maxDang: currentMaxDang),
                      let animationDuration = self?.calculateCircleAnimationDuration(dang: currentDayDang,
                                                                                     maxDang: currentMaxDang) else { return }
                self?.currentCount.accept($0)
                self?.selectedCircleColor.accept(circleColor)
                self?.selectedCircleBackgroundColor.accept(circleBackgroundColor)
                self?.selectedDangValue.accept(String(currentDayDang))
                self?.selectedMaxDangValue.accept(String(currentMaxDang))
                self?.circleDangValue.accept(circleDangValue)
                self?.circlePercentValue.accept(circlePercentValue)
                self?.currentDangValue.accept(currentDayDang)
                self?.currentMaxDangValue.accept(currentMaxDang)
                self?.circleAnimationDuration.accept(animationDuration)
                self?.selectedAnimationLineColor.accept(animationLineColor)
                
            })
            .disposed(by: disposeBag)
        
        selectedCellData
            .subscribe(onNext: { [weak self] in
                guard let indexPathItem = $0.indexPath?.item else { return }
                self?.calendarUseCase.calculateCurrentLine(currentDay: indexPathItem)
                
                guard let orderNumber = self?.calendarUseCase.currentLine.value,
                      let yValue = self?.calculateRevertAnimationYValue(value: orderNumber) else { return }
                self?.currentLineYValue.accept(yValue)
            })
            .disposed(by: disposeBag)
        
        retriveMonthDangData()
    }
    
    func retriveMonthDangData() {
        homeUseCase.retriveMouthData()
            .map { CalendarMonthDangEntity(calendarMonthDang: $0) }
            .subscribe(onNext: { [weak self] in
                self?.monthData.accept($0)
            })
            .disposed(by: disposeBag)
    }
    
    func scrolledCalendarToLeft() {
        calendarUseCase.createPreviousCalendarData()
            .map {
                [BatteryEntity(calendar: $0)]+self.batteryViewCalendarData.value
            }
            .subscribe(onNext: { [weak self] in
                self?.batteryViewCalendarData.accept($0)
                self?.pagingState.accept(.left)
                self?.reloadData.accept(())
            })
            .disposed(by: disposeBag)
    }
    
    func scrolledCalendarToRight() {
        calendarUseCase.createNextCalendarData()
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
    
    func handlePagingState(_ data: PagingState, view: UIView) {
        guard let view = view as? BatteryView else { return }
        switch data {
        case .left:
            UIView.performWithoutAnimation {
                view.calendarCollectionView.insertItems(at: [.init(item: 0, section: 0)])
                view.calendarCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0),
                                                         at: .centeredHorizontally,
                                                         animated: false)
                view.calendarCollectionView.reloadItems(at: [.init(item: 0, section: 0)])
            }
        case .right(let index):
            view.calendarCollectionView.insertItems(at: [.init(item: index, section: 0)])
            view.calendarCollectionView.reloadItems(at: [.init(item: index, section: 0)])
        case .empty:
            break
        }
    }
    
    func calculateSelectedDayXPoint() {
        let count = batteryViewCalendarData.value.count
        
        for i in 0..<count {
            if batteryViewCalendarData.value[i].yearMonth == selectedCellData.value.yearMonth {
                let point = CGPoint(x: UIScreen.main.bounds.maxX*CGFloat(i), y: .zero)
                currentXPoint.accept(i)
                currentDateCGPoint.accept(point)
                break
            } else {
                continue
            }
        }
    }
    
    private func calculateRevertAnimationYValue(value: Int) -> CGFloat {
        switch value {
        case 0:
            return UIScreen.main.bounds.maxY*((CGFloat(63))/844)
        case 1:
            return UIScreen.main.bounds.maxY*((CGFloat(3))/844)
        case 2:
            return -(UIScreen.main.bounds.maxY*((CGFloat(57))/844))
        case 3:
            return -(UIScreen.main.bounds.maxY*((CGFloat(117))/844))
        case 4:
            return -(UIScreen.main.bounds.maxY*((CGFloat(177))/844))
        case 5:
            return -(UIScreen.main.bounds.maxY*((CGFloat(237))/844))
        default:
            return -(UIScreen.main.bounds.maxY*((CGFloat(297))/844))
        }
    }
    
    func giveDirections(currentPoint: CGFloat) {
        self.currentPoint.accept(currentPoint)
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
        let result = currentPoint.value / maxXValue
        
        switch scrollDirection.value {
        case .left:
            scrolledCalendarToLeft()
            currentXPoint.accept(1)
        case .center:
            currentXPoint.accept(Int(result))
            break
        case .right:
            scrolledCalendarToRight()
            let number = batteryViewCalendarData.value.count
            currentXPoint.accept(Int(number-2))
            break
        }
    }
    
    func calculateMonthDangDataNumber(dang: Double,
                                              maxDang: Double) -> CGFloat {
        let dangValueNumber: Double = (dang/maxDang)*Double(80)
        let number3: Double = 80*(dangValueNumber/80)
        let result: Double = number3/100
        
        return CGFloat(result)
    }
    
    func calculatePercentValue(dang: Double,
                               maxDang: Double) -> Int {
        let dangValueNumber: Double = (dang/maxDang)*Double(100)
        let division: Double = 100*(dangValueNumber/100)
        
        
        return Int(division)
    }
    
    func calculateCircleProgressBarColor(dang: Double,
                                         maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.customCircleAnimationColor(.circleAnimationColorRed).cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.customCircleAnimationColor(.circleAnimationColorYellow).cgColor
        } else {
            return UIColor.customCircleAnimationColor(.circleAnimationColorGreen).cgColor
        }
    }
    
    func calculateCircleProgressBackgroundColor(dang: Double,
                                                maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.customCircleBackgroundColor(.circleBackgroundColorRed).cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.customCircleBackgroundColor(.circleBackgroundColorYellow).cgColor
        } else {
            return UIColor.customCircleBackgroundColor(.circleBackgroundColorGreen).cgColor
        }
    }
    
    func calculateCirclePercentLineColor(dang: Double,
                                         maxDang: Double) -> CGColor {
        let colorCalculateNumber: Double = (dang/maxDang)*100
        
        if colorCalculateNumber > 63 {
            return UIColor.customCircleColor(.circleColorRed).cgColor
        } else if colorCalculateNumber > 33 {
            return UIColor.customCircleColor(.circleColorYellow).cgColor
        } else {
            return UIColor.customCircleColor(.circleColorGreen).cgColor
        }
    }
    
    func calculateCircleAnimationDuration(dang: Double, maxDang: Double) -> Double {
        return Double((dang/maxDang)*3)
    }
    
    func didTapCalendarViewCell(selectedDangData: Double,
                                selectedMaxDangData: Double,
                                cell: DaysCollectionViewCell) {
        let circlePercentValue = calculatePercentValue(dang: selectedDangData,
                                                       maxDang: selectedMaxDangData)
        let circleDangValue = calculateMonthDangDataNumber(dang: selectedDangData,
                                                           maxDang: selectedMaxDangData)
        let circleColor = calculateCircleProgressBarColor(dang: selectedDangData,
                                                          maxDang: selectedMaxDangData)
        let circleBackgroundColor = calculateCircleProgressBackgroundColor(dang: selectedDangData,
                                                                           maxDang: selectedMaxDangData)
        let animationLineColor = calculateCirclePercentLineColor(dang: selectedDangData,
                                                                 maxDang: selectedMaxDangData)
        let animationDuration = calculateCircleAnimationDuration(dang: selectedDangData,
                                                                 maxDang: selectedMaxDangData)
        
        self.circleDangValue.accept(circleDangValue)
        self.circlePercentValue.accept(circlePercentValue)
        self.selectedDangValue.accept(String(selectedDangData))
        self.selectedMaxDangValue.accept(String(selectedMaxDangData))
        self.selectedCircleColor.accept(circleColor)
        self.selectedCircleBackgroundColor.accept(circleBackgroundColor)
        self.selectedAnimationLineColor.accept(animationLineColor)
        self.circleAnimationDuration.accept(animationDuration)
        cell.selectedView.backgroundColor = .selectedCellViewColor(.selectedCellViewColor)
        homeViewController?.resetBatteryViewConfigure()
    }
    
    func calculateCurrentDayLineViewColor(indexPath: IndexPath,
                                          yearMonth: String,
                                          cell: DaysCollectionViewCell,
                                          collectionView: UICollectionView) {
        
        // MARK: cell 클릭시 스팟 저장
        if indexPath.item == selectedCellData.value.indexPath?.item && selectedCellData.value.yearMonth == yearMonth {
            cell.selectedView.backgroundColor = .selectedCellViewColor(.selectedCellViewColor)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.selectedView.backgroundColor = .selectedCellViewColor(.selectedCellViewHiddenColor)
        }
        
        
        
        if indexPath.item == currentCount.value && currentYearMonth.value == yearMonth {
            cell.selectedLineView.layer.borderColor = UIColor.selectedCellLineViewColor(.selectedCellLineColor)
        } else {
            cell.selectedLineView.layer.borderColor = UIColor.selectedCellLineViewColor(.selectedCellLineHiddenColor)
        }
        
        
    }
}

