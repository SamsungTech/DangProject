//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation
import RxRelay
import RxSwift

enum GraphDataType {
    case year
    case month
    case day
}

protocol GraphViewModelInputProtocol {
    func branchOutGraphDataType(_ data: Int)
}

protocol GraphViewModelOutputProtocol {
    var graphDataRelay: BehaviorRelay<GraphDomainModel> { get }
    var graphDataTypeRelay: BehaviorRelay<GraphDataType> { get }
}

protocol GraphViewModelProtocol: GraphViewModelInputProtocol, GraphViewModelOutputProtocol {
    
}

class GraphViewModel: GraphViewModelProtocol {
    private let disposeBag = DisposeBag()
    private let fetchGraphDataUseCase: FetchGraphDataUseCase
    var graphDataRelay = BehaviorRelay<GraphDomainModel>(value: .empty)
    var graphDataTypeRelay = BehaviorRelay<GraphDataType>(value: .day)
    
    init(fetchGraphDataUseCase: FetchGraphDataUseCase) {
        self.fetchGraphDataUseCase = fetchGraphDataUseCase
        bindGraphDataUseCase()
    }
    
    private func bindGraphDataUseCase() {
        fetchGraphDataUseCase.yearMonthDayDataSubject
            .subscribe(onNext: { [weak self] graphData in
                self?.graphDataRelay.accept(graphData)
            })
            .disposed(by: disposeBag)
    }
    
    func branchOutGraphDataType(_ data: Int) {
        if data == 0 {
            graphDataTypeRelay.accept(.day)
        } else if data == 1 {
            graphDataTypeRelay.accept(.month)
        } else {
            graphDataTypeRelay.accept(.year)
        }
    }
    
    func createGraphLabelText(_ type: GraphDataType) -> [String] {
        let currentDateNumber = createCurrentDateTimeType(type)
        var stringArray: [String] = []

        for i in 0...6 {
            if currentDateNumber-i <= 0 {
                let date = Date.monthDaysCount(currentDateNumber)
                stringArray.append(String(date))
            } else {
                stringArray.append(String(currentDateNumber-i))
            }
        }
        let reversedArray: [String] = stringArray.reversed()
        return reversedArray
    }
    
    private func createCurrentDateTimeType(_ type: GraphDataType) -> Int {
        let currentDay = DateComponents.currentDateTimeComponents()
        switch type {
        case .year:
            return currentDay.year ?? 0
        case .month:
            return currentDay.month ?? 0
        case .day:
            return currentDay.day ?? 0
        }
    }
}
