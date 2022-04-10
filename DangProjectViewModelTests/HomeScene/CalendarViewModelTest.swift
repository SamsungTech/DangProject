//
//  CalendarViewModelTest.swift
//  DangProjectTests
//
//  Created by 김동우 on 2022/04/06.
//

import XCTest

import RxRelay
import RxSwift
import RxTest
@testable import DangProject

class CalendarViewModelTest: XCTestCase {
    private var viewModel: CalendarViewModelProtocol!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var mockBatteryEntityData = BatteryEntity(
        daysArray: [],
        week: [],
        yearMonth: "2022년 4월",
        isHiddenArray: [false, true, false],
        dangArray: [],
        maxDangArray: [],
        isCurrentDayArray: []
    )
    
    override func setUpWithError() throws {
        self.viewModel = CalendarViewModel(
            calendarData: mockBatteryEntityData
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
        self.scheduler = nil
    }
    
    func test_compareCurrentDayCellData_normal() {
        let testableObserver = self.scheduler.createObserver(CurrentDayLineState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.compareCurrentDayCellData(
                    indexPath: IndexPath(item: 0, section: 0),
                    yearMonth: "",
                    cell: cell,
                    currentCount: 0,
                    currentYearMonth: ""
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.currentDayCellLineViewState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .normal(cell))]
        )
    }
    
    func test_compareCurrentDayCellData_hidden() {
        let testableObserver = self.scheduler.createObserver(CurrentDayLineState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.compareCurrentDayCellData(
                    indexPath: IndexPath(item: 0, section: 0),
                    yearMonth: "",
                    cell: cell,
                    currentCount: 1,
                    currentYearMonth: "no"
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.currentDayCellLineViewState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .hidden(cell))]
        )
    }
    
    func test_compareSelectedDayCellData_normal() {
        let testableObserver = self.scheduler.createObserver(SelectedItemFillViewState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.compareSelectedDayCellData(
                    indexPath: IndexPath(item: 0, section: 0),
                    yearMonth: "",
                    cell: cell,
                    collectionView: collectionView,
                    selectedCellIndexPath: 0,
                    selectedCellYearMonth: ""
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedCellFillViewState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .normal(collectionView,
                               cell,
                               IndexPath(item: 0, section: 0)))]
        )
    }
    
    func test_compareSelectedDayCellData_hidden() {
        let testableObserver = self.scheduler.createObserver(SelectedItemFillViewState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.compareSelectedDayCellData(
                    indexPath: IndexPath(item: 0, section: 0),
                    yearMonth: "",
                    cell: cell,
                    collectionView: collectionView,
                    selectedCellIndexPath: 1,
                    selectedCellYearMonth: "no"
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedCellFillViewState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .hidden(cell))]
        )
    }
    
    func test_calculateSelectedItemIsHiddenValue_true() {
        let testableObserver = self.scheduler.createObserver(SelectedItemIsHiddenState.self)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.calculateSelectedItemIsHiddenValue(
                    collectionView: collectionView,
                    indexPath: IndexPath(item: 1, section: 0)
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedCalendarCellIsHidden
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .selectedTrue(collectionView))]
        )
    }
    
    func test_calculateSelectedItemIsHiddenValue_false() {
        let testableObserver = self.scheduler.createObserver(SelectedItemIsHiddenState.self)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.calculateSelectedItemIsHiddenValue(
                    collectionView: collectionView,
                    indexPath: IndexPath(item: 0, section: 0)
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedCalendarCellIsHidden
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .empty),
             .next(10, .selectedFalse(collectionView,
                                      IndexPath(item: 0, section: 0)))]
        )
    }
    
    func test_calculateDeSelectedItemIsHiddenValue_true() {
        let testableObserver = self.scheduler.createObserver(DeSelectedItemIsHiddenState.self)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.calculateDeSelectedItemIsHiddenValue(
                    collectionView: collectionView,
                    indexPath: IndexPath(item: 1, section: 0)
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.deSelectedCalendarCellIsHidden
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .DeSelectedTrue),
             .next(10, .DeSelectedTrue)]
        )
    }
    
    func test_calculateDeSelectedItemIsHiddenValue_false() {
        let testableObserver = self.scheduler.createObserver(DeSelectedItemIsHiddenState.self)
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.calculateDeSelectedItemIsHiddenValue(
                    collectionView: collectionView,
                    indexPath: IndexPath(item: 0, section: 0)
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.deSelectedCalendarCellIsHidden
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .DeSelectedTrue),
             .next(10, .DeSelectedFalse(collectionView,
                                        IndexPath(item: 0, section: 0)))]
        )
    }
    
    func test_compareSelectedYearMonthData_true() {
        let testableObserver = self.scheduler.createObserver(YearMonthState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.compareSelectedYearMonthData(
                    collectionView: collectionView,
                    selectedYearMonth: "2022년 4월",
                    indexPath: IndexPath(item: 0, section: 0),
                    cell: cell
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedYearMonthState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .differ),
             .next(10, .match(collectionView,
                              IndexPath(item: 0, section: 0),
                              cell))]
        )
    }
    
    func test_compareSelectedYearMonthData_false() {
        let testableObserver = self.scheduler.createObserver(YearMonthState.self)
        let cell = DaysCollectionViewCell(frame: .zero)
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.viewModel.calendarData.accept(
                    CalendarStackViewEntity(
                        batteryEntity: self?.mockBatteryEntityData ?? .empty
                    )
                )
                self?.viewModel.compareSelectedYearMonthData(
                    collectionView: collectionView,
                    selectedYearMonth: "2022년 3월",
                    indexPath: IndexPath(item: 0, section: 0),
                    cell: cell
                )
            })
            .disposed(by: disposeBag)
        
        self.viewModel.selectedYearMonthState
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        
        XCTAssertEqual(
            testableObserver.events,
            [.next(0, .differ),
             .next(10, .differ)]
        )
    }
}
