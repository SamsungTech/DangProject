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
    private var mockBatteryEntityData = BatteryEntity.empty
    
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
    
//    func test() {
//        
//    }
//    func test() {
//        
//    }
//    func test() {
//        
//    }
//    func test() {
//        
//    }
//    func test() {
//        
//    }
}
