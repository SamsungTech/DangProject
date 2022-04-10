//
//  DaysCellViewModelTest.swift
//  DangProjectTests
//
//  Created by 김동우 on 2022/04/06.
//

import XCTest

import RxRelay
import RxSwift
import RxTest
@testable import DangProject

class DaysCellViewModelTest: XCTestCase {
    private var viewModel: DaysCellViewModelProtocol!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var mockBatteryEntityData = CalendarStackViewEntity.empty
    
    override func setUpWithError() throws {
        self.viewModel = DaysCellViewModel(
            calendarData: mockBatteryEntityData,
            indexPathItem: 0
        )
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.disposeBag = nil
        self.scheduler = nil
    }
    
    func test_calculateAlphaHiddenValues() {
        
    }
    
    func test_calculateCurrentDayAlphaValues() {
        
    }
}
