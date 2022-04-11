//
//  CalendarUseCaseTest.swift
//  DangProjectTests
//
//  Created by 김동우 on 2022/04/03.
//

import XCTest
import RxTest

import RxSwift
import RxRelay
@testable import DangProject

class CalendarUseCaseTest: XCTestCase {
    var useCase: CalendarUseCaseProtocol?
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    var mockHomeRepository: HomeRepositoryProtocol!
    var calendarDummyData = DummyCalendarEntity()
    
    override func setUpWithError() throws {
        self.mockHomeRepository = MockHomeRepository()
        self.useCase = CalendarUseCase(repository: self.mockHomeRepository)
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.useCase = nil
        self.disposeBag = nil
    }
    
    // MARK: initCalculationDaysInMonth
    func test_create_initCalculationDaysInMonth() {
        let testableObserver = self.scheduler.createObserver([CalendarEntity].self)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.useCase?.initCalculationDaysInMonth()
            })
            .disposed(by: disposeBag)
        
        self.useCase?.calendarDataArraySubject
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events,
                       [.next(0, []),
                        .next(10, calendarDummyData.ExpectedInitCalendarDummyData)])
    }
}

extension CalendarUseCaseTest {
    // MARK: CalculateCurrentLine Test - 테스트 완료!!
    func test_calculateCurrentLine() {
        let testableObserver = self.scheduler.createObserver(Int.self)
        
        // MARK: CalculateCurrentM
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.useCase?.calculateCurrentMonth()
            })
            .disposed(by: disposeBag)
        
        self.useCase?.currentLine
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events, [.next(10, 2)])
    }
    
    // MARK: PreviousMonthData Test - 테스트 완료!!
    func test_create_PreviousMonthData() {
        let testableObserver = self.scheduler.createObserver(CalendarEntity.self)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.useCase?.createPreviousCalendarData()
            })
            .disposed(by: disposeBag)
        
        self.useCase?.calendarPreviousMonthData
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events,
                       [.next(10, calendarDummyData.ExpectedPreviousCalendarDummyData)])
    }
    
    // MARK: NextMonthData Test - 테스트 완료!!
    func test_create_nextMonthData() {
        let testableObserver = self.scheduler.createObserver(CalendarEntity.self)
        
        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.useCase?.createNextCalendarData()
            })
            .disposed(by: disposeBag)
        
        self.useCase?.calendarNextMonthData
            .subscribe(testableObserver)
            .disposed(by: disposeBag)
        
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events,
                       [.next(10, calendarDummyData.ExpectedNextCalendarDummyData)])
    }
}
