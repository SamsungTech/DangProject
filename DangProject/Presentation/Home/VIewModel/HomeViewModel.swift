//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift
import RxRelay

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
    private var disposeBag = DisposeBag()
    private var currentDateYearMonth = ""
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
    var currentLineNumber = BehaviorRelay<CGFloat>(value: 0)
    var circleColor: [CGColor] = []
    var circleNumber: [CGFloat] = []
    
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
                self?.batteryViewCalendarData.accept($0)
                self?.reloadData.accept(())
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentLine
            .map { self.calculateCalendarTopAnchor(value: $0) }
            .subscribe(onNext: { [weak self] in
                self?.currentLineNumber.accept($0)
            })
            .disposed(by: disposeBag)
        
        calendarUseCase.currentDateYearMonth
            .subscribe(onNext: { [weak self] in
                self?.currentDateYearMonth = $0
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
    
    func calculateCurrentDatePoint() {
        let count = batteryViewCalendarData.value.count
        
        for i in 0..<count {
            if batteryViewCalendarData.value[i].yearMonth == currentDateYearMonth {
                let point = CGPoint(x: UIScreen.main.bounds.maxX*CGFloat(i), y: .zero)
                currentXPoint.accept(i)
                currentDateCGPoint.accept(point)
                break
            } else {
                continue
            }
        }
    }
    
    private func calculateCalendarTopAnchor(value: Int) -> CGFloat {
        switch value {
        case 0:
            return UIScreen.main.bounds.maxY*((CGFloat(110))/844)
        case 1:
            return UIScreen.main.bounds.maxY*((CGFloat(50))/844)
        case 2:
            return -(UIScreen.main.bounds.maxY*((CGFloat(10))/844))
        case 3:
            return -(UIScreen.main.bounds.maxY*((CGFloat(60))/844))
        case 4:
            return -(UIScreen.main.bounds.maxY*((CGFloat(120))/844))
        case 5:
            return -(UIScreen.main.bounds.maxY*((CGFloat(180))/844))
        default:
            return -(UIScreen.main.bounds.maxY*((CGFloat(240))/844))
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
}

