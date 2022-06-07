//
//  MockHomeUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/06.
//

import Foundation

import RxSwift
import RxRelay

class MockHomeUseCase: HomeUseCaseProtocol {
    var yearMonthWeekDangData = BehaviorRelay<YearMonthWeekDang>(value: .empty)
    
    func execute() {
        self.yearMonthWeekDangData.accept(
            YearMonthWeekDang(dangGeneral: DangGeneral(tempDang: ["1"],
                                                       tempFoodName: ["감자탕"],
                                                       weekDang: ["1"],
                                                       monthDang: [1],
                                                       monthMaxDang: [1],
                                                       yearDang: ["1"]),
                              todaySugarSum: 10.0)
        )
    }
}
