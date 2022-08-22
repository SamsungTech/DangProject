//
//  GraphItemViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/02/15.
//

import Foundation

import RxSwift
import RxRelay

protocol GraphViewModelInputProtocol {
    
}

protocol GraphViewModelOutputProtocol {
    
}

protocol GraphViewModelProtocol: GraphViewModelInputProtocol, GraphViewModelOutputProtocol { }

class GraphViewModel: GraphViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private let fetchEatenFoodsUseCase: FetchEatenFoodsUseCase
    
    init(fetchEatenFoodsUseCase: FetchEatenFoodsUseCase) {
        self.fetchEatenFoodsUseCase = fetchEatenFoodsUseCase
    }
    
}
