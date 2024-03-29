//
//  FetchEatenFoodsUseCase.swift
//  DangProject
//
//  Created by 김성원 on 2022/06/15.
//

import Foundation

import RxSwift

protocol FetchEatenFoodsUseCase {
    var eatenFoodsObservable: PublishSubject<EatenFoodsPerDayDomainModel> { get }
    var totalMonthsDataObservable: PublishSubject<[[EatenFoodsPerDayDomainModel]]> { get }
    var sevenMonthsTotalSugarObservable: PublishSubject<(DateComponents, [TotalSugarPerMonthDomainModel])> { get }
    func fetchEatenFoods(date: Date)
    func fetchCurrentMonthsData(completion: @escaping(Bool)->Void)
    func fetchMonthsData(month: DateComponents, completion: @escaping(Bool)->Void)
    func fetchNextMonthData(month: DateComponents)
    func fetchSevenMonthsTotalSugar(from dateComponents: DateComponents)
}
