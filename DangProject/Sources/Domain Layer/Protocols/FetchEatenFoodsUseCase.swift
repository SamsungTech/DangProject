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
    var previousCurrentNextMonthsDataObservable: PublishSubject<[[EatenFoodsPerDayDomainModel]]> { get }
    func fetchEatenFoods(date: Date)
    func fetchTotalMonthsData(dateComponents: DateComponents)
    func fetchMonthData(dateComponents: DateComponents) -> [EatenFoodsPerDayDomainModel]
}
