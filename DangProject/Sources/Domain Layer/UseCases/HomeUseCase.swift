//
//  HomeUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation

import RxSwift
import RxRelay

// MARK: 쓸데없이 여러개의 subject만들지말고 한개의 subject안에 다 넣기

// MARK: 새로운 음식 추가하는 순간 데이터 다시 리셋 시켜야하기 때문에 레포지토리에서 다시 전체를 끌고온다

class HomeUseCase: HomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol
    private let disposeBag = DisposeBag()
    var yearMonthWeekDangData = BehaviorRelay<YearMonthWeekDang>(value: .empty)
    
    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() {
        let dangGeneralData = repository.dangGeneralData
        
        yearMonthWeekDangData.accept(
            YearMonthWeekDang(
                dangGeneral: dangGeneralData,
                todaySugarSum: calculateDangArray(value: dangGeneralData.tempDang)
            )
        )
    }
}

extension HomeUseCase {
    private func calculateDangArray(value: [String]) -> Double {
        var result = 0.0
        
        for item in value {
            guard let item = Double(item) else { return 0.0 }
            result += item
        }
        
        return result
    }
}
