//
//  HomeViewModelTest.swift
//  DangProjectTests
//
//  Created by 김동우 on 2022/04/05.
//

import XCTest

import RxRelay
import RxSwift
import RxTest
@testable import DangProject

class HomeViewModelTest: XCTestCase {
    private var viewModel: HomeViewModelProtocol!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    override func setUpWithError() throws {
        self.viewModel = HomeViewModel(
            useCase: MockHomeUseCase(),
            calendarUseCase: MockCalendarUseCase()
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
        self.scheduler = nil
    }
    
    func test_viewDidLoad_HomeViewData() {
        let testableObserver = self.scheduler.createObserver(DangComprehensive.self)
        
        let empty = DangComprehensive.empty
        let expectedDangComprehensive = DangComprehensive(
            yearMonthWeekDang: YearMonthWeekDang(
                dangGeneral: DangGeneral(
                    tempDang: ["1"],
                    tempFoodName: ["감자탕"],
                    weekDang: ["1"],
                    monthDang: [1],
                    monthMaxDang: [1],
                    yearDang: ["1"]
                ),
                todaySugarSum: 10.0
            )
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.viewDidLoad()
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.dangComprehensiveData
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, empty),
             .next(10, expectedDangComprehensive)]
        )
    }
    
    func test_calendarScaleState() {
        let testableObserver = self.scheduler.createObserver(CalendarScaleState.self)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calculateCalendarScaleState()
            })
            .disposed(by: disposeBag)
        
        self.scheduler.createColdObservable([.next(20, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calculateCalendarScaleState()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.calendarScaleAnimation
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(testableObserver.events,
                       [.next(0, .revert),
                        .next(10, .expand),
                        .next(20, .revert)])
    }
    
    func test_calculateSelectedDayXPoint() {
        let testableObserver1 = self.scheduler.createObserver(Int.self)
        let testableObserver2 = self.scheduler.createObserver(CGPoint.self)

        let mockBatteryViewCalendarData = [
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(
                calendar: CalendarEntity(
                    days: [],
                    week: [],
                    yearMonth: "2022년 4월",
                    isHiddenArray: [],
                    dangArray: [],
                    maxDangArray: [],
                    isCurrentDayArray: []
                )
            )
        ]
        
        let mockSelectedCellData = SelectedCalendarCellEntity(
            yearMonth: "2022년 4월",
            indexPath: IndexPath(item: 0,
                                 section: 0)
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.selectedCellData.accept(
                    mockSelectedCellData
                )
                self?.viewModel.calculateSelectedDayXPoint()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.currentXPoint
            .subscribe(testableObserver1)
            .disposed(by: disposeBag)
        
        self.viewModel.currentDateCGPoint
            .subscribe(testableObserver2)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver1.events,
            [.next(0, 1),
             .next(10, 4)]
        )
        XCTAssertEqual(
            testableObserver2.events,
            [.next(0, CGPoint(x: 0.0,
                              y: .zero)),
             .next(10, CGPoint(x: UIScreen.main.bounds.maxX*(4),
                               y: .zero))]
        )
    }
    
    func test_afterSettingDirection() {
        let testableObserver1 = self.scheduler.createObserver(ScrollDirection.self)
        let testableObserver2 = self.scheduler.createObserver(Int.self)
        
        let mockBatteryViewCalendarData = [
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty)
        ]
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 0)
                self?.viewModel.calculateAfterSettingDirection()
            })
            .disposed(by: disposeBag)
        
        self.scheduler.createColdObservable([.next(20, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 780)
                self?.viewModel.calculateAfterSettingDirection()
            })
            .disposed(by: disposeBag)
        
        self.scheduler.createColdObservable([.next(30, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 1560)
                self?.viewModel.calculateAfterSettingDirection()
            })
            .disposed(by: disposeBag)
        
        self.viewModel.scrollDirection
            .subscribe(testableObserver1)
            .disposed(by: disposeBag)
        
        self.viewModel.currentXPoint
            .subscribe(testableObserver2)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver1.events,
            [.next(0, .center),
             .next(10, .left),
             .next(20, .center),
             .next(30, .right)]
        )
        XCTAssertEqual(
            testableObserver2.events,
            [.next(0, 1),
             .next(10, 1),
             .next(20, 2),
             .next(30, 3)]
        )
    }
    
    func test_giveDirection() {
        let directionTestableObserver = self.scheduler.createObserver(ScrollDirection.self)
        
        let mockBatteryViewCalendarData = [
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty),
            BatteryEntity(calendar: .empty)
        ]
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 0)
            })
            .disposed(by: disposeBag)
        
        self.scheduler.createColdObservable([.next(20, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 390)
            })
            .disposed(by: disposeBag)
        
        self.scheduler.createColdObservable([.next(30, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.batteryViewCalendarData.accept(
                    mockBatteryViewCalendarData
                )
                self?.viewModel.giveDirections(currentPoint: 780)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.scrollDirection
            .subscribe(directionTestableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            directionTestableObserver.events,
            [.next(0, ScrollDirection.center),
             .next(10, ScrollDirection.left),
             .next(20, ScrollDirection.center),
             .next(30, ScrollDirection.right)]
        )
    }
    
    func test_didTapCalendarViewCell() {
        let testableObserver = self.scheduler.createObserver(SelectedCellEntity.self)
        
        let expectedResult1 = SelectedCellEntity.empty
        let expectedResult2 = SelectedCellEntity(
            selectedCircleColor: UIColor.circleAnimationColorYellow.cgColor,
            selectedCircleBackgroundColor: UIColor.circleBackgroundColorYellow.cgColor,
            selectedDangValue: "10.0",
            selectedMaxDangValue: "20.0",
            circleDangValue: 0.4,
            circlePercentValue: 50,
            circleAnimationDuration: 1.5,
            selectedAnimationLineColor: UIColor.circleColorYellow.cgColor
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapCalendarViewCell(
                    selectedDangData: 10,
                    selectedMaxDangData: 20
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedCellViewData
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, expectedResult1),
             .next(10, expectedResult2)]
        )
    }
}
