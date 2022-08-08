//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay
import RxSwift

struct GraphViewEntity {
    static let empty: Self = .init(weekDang: [],
                                   monthDang: [],
                                   yearDang: [])
    var weekDang: [String]?
    var monthDang: [Double]?
    var yearDang: [String]?
    
    init(weekDang: [String],
         monthDang: [Double],
         yearDang: [String]) {
        self.weekDang = weekDang
        self.monthDang = monthDang
        self.yearDang = yearDang
    }
}

class GraphViewModel {
    private let disposeBag = DisposeBag()
    private let fetchGraphDataUseCase: FetchGraphDataUseCase
    
    init(fetchGraphDataUseCase: FetchGraphDataUseCase) {
        self.fetchGraphDataUseCase = fetchGraphDataUseCase
        bindGraphDataUseCase()
    }
    
    private func bindGraphDataUseCase() {
        // MARK: 데이터가 한번에 오지 않고 두번에 걸쳐서 오는듯?
        // MARK: 캐싱작업을 따로 해놓지 않음 해야 될듯
        fetchGraphDataUseCase.createGraphThisYearMonthDayData()
        
        fetchGraphDataUseCase.yearMonthDayDataRelay
            .subscribe(onNext: { [weak self] in
                
                
                print($0)
            })
            .disposed(by: disposeBag)
        
        fetchGraphDataUseCase.yearMonthDayDataSubject
            .subscribe(onNext: { [weak self] in
                
                print($0)
            })
            .disposed(by: disposeBag)
    }
}
