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
    var sixMonthsTotalSugarObservable: PublishSubject<(DateComponents, [TotalSugarPerMonthDomainModel])> { get }
    func fetchEatenFoods(date: Date)
    func fetchCurrentMonthsData()
    func fetchMonthsData(month: DateComponents)
    func fetchNextMonthData(month: DateComponents)
    func fetchSevenMonthsTotalSugar(from dateComponents: DateComponents)
}
