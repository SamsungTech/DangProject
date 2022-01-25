//
//  HomeViewModel.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelInputProtocol {
    func viewDidLoad()
}

protocol HomeViewModelOutputProtocol {
    var tempData: BehaviorRelay<[tempNutrient]> { get }
}

protocol HomeViewModelProtocol: HomeViewModelInputProtocol, HomeViewModelOutputProtocol {}

class HomeViewModel: HomeViewModelProtocol {
    private var useCase: HomeUseCase
    var disposeBag = DisposeBag()
    var tempData = BehaviorRelay<[tempNutrient]>(value: [])
    
    init(useCase: HomeUseCase) {
        self.useCase = useCase
    }
}

extension HomeViewModel {
    func viewDidLoad() {
        useCase.execute()
            .subscribe(onNext: { data in
                self.tempData.accept(data)
            })
            .disposed(by: disposeBag)
    }
}
