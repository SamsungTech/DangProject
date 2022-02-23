//
//  HomeUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation
import RxSwift

class HomeUseCase {
    private let repository: TempRepositoryProtocol
    var sum: Double = 0.0
    
    var nutrient: [tempNutrient] = [
        tempNutrient(dang: "0.5", foodName: "김치말이국수"),
        tempNutrient(dang: "0.8", foodName: "김치볶음밥"),
        tempNutrient(dang: "1.5", foodName: "라면"),
        tempNutrient(dang: "1.8", foodName: "탕수육"),
        tempNutrient(dang: "2.0", foodName: "냉모밀"),
        tempNutrient(dang: "5.0", foodName: "나시고랭"),
        tempNutrient(dang: "1.2", foodName: "깍두기")
    ]
    var weekData: [tempNutrient] = [
        tempNutrient(dang: "5.5", foodName: "김치말이국수"),
        tempNutrient(dang: "8.8", foodName: "김치볶음밥"),
        tempNutrient(dang: "1.5", foodName: "라면"),
        tempNutrient(dang: "11.8", foodName: "탕수육"),
        tempNutrient(dang: "22.0", foodName: "냉모밀"),
        tempNutrient(dang: "10.0", foodName: "나시고랭"),
        tempNutrient(dang: "22.2", foodName: "깍두기")
    ]
    var mouthData: [tempNutrient] = [
        tempNutrient(dang: "20.5", foodName: "김치말이국수"),
        tempNutrient(dang: "21.8", foodName: "김치볶음밥"),
        tempNutrient(dang: "18.5", foodName: "라면"),
        tempNutrient(dang: "5.8", foodName: "탕수육"),
        tempNutrient(dang: "8.0", foodName: "냉모밀"),
        tempNutrient(dang: "10.0", foodName: "나시고랭"),
        tempNutrient(dang: "20.2", foodName: "깍두기")
    ]
    var yearData: [tempNutrient] = [
        tempNutrient(dang: "10.5", foodName: "김치말이국수"),
        tempNutrient(dang: "5.8", foodName: "김치볶음밥"),
        tempNutrient(dang: "20.5", foodName: "라면"),
        tempNutrient(dang: "5.8", foodName: "탕수육"),
        tempNutrient(dang: "25.0", foodName: "냉모밀"),
        tempNutrient(dang: "20.0", foodName: "나시고랭"),
        tempNutrient(dang: "10.2", foodName: "깍두기")
    ]
    
    init(repository: TempRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() -> Observable<[tempNutrient]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(self.nutrient)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    // MARK: 여기서 계산을 다하고 viewModel한테 가야된다!
    func retriveWeekData() -> Observable<[tempNutrient]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(self.weekData)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func retriveMouthData() -> Observable<[tempNutrient]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(self.mouthData)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func retriveYearData() -> Observable<[tempNutrient]> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(self.yearData)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func calculateSugarSum() -> Observable<sugarSum> {
        // MARK: 오퍼레이터로 만들수 있을 것 같은데?
        for item in self.nutrient {
            sum += Double(item.dang ?? "") ?? 0.0
        }
        
        let sugarSum = sugarSum.init(sum: sum)
        
        
        return Observable.create { (observer) -> Disposable in
            observer.onNext(sugarSum)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}


