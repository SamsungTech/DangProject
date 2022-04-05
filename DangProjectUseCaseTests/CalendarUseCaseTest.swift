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
    
    // MARK: 초기화 코드를 작성하는 함수로 클래스의 각 테스트 함수의 호출 전에 호출되는 함수다.
    override func setUpWithError() throws {
        self.mockHomeRepository = MockHomeRepository()
        self.useCase = CalendarUseCase(repository: self.mockHomeRepository)
        self.scheduler = TestScheduler(initialClock: 0)
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Hot Observable - 실시간 Live Streaming -> UI에 어떤 요소를 표현할때
    // MARK: Cold Observable - 왓차, 넷플릭스 처음부터 끝까지 원하는 부분을 시청 가능
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.useCase = nil
        self.disposeBag = nil
    }
    
    func test_calculateMonthCalendar() {
        let testableObserver = self.scheduler.createObserver([String].self)

        self.scheduler.createColdObservable([.next(10, ())])
            .subscribe(onNext: { [weak self] in
                self?.useCase?.calculateMonthCalendar()
            })
            .disposed(by: disposeBag)
        
        
        
    }
    
    // MARK: 1. initCalculationDaysInMonth
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
        print(testableObserver.events)
        self.scheduler.start()
        XCTAssertEqual(testableObserver.events,
                       [.next(10, calendarDummyData.ExpectedInitCalendarDummyData)])
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
        XCTAssertEqual(testableObserver.events, [.next(10, 1)])
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
