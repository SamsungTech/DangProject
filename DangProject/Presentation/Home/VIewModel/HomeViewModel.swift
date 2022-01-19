//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift

protocol HomeViewModelInputProtocol {
    
}

protocol HomeViewModelOutputProtocol {
    
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var useCase: HomeUseCase
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}
