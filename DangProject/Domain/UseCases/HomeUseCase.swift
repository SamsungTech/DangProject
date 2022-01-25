//
//  HomeUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift

class HomeUseCase {
    private let repository: TempRepository
    
    init(repository: TempRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<[tempNutrient]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(self.repository.nutrient)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
}
