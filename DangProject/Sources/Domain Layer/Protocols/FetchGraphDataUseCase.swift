//
//  FetchGraphDataUseCase.swift
//  DangProject
//
//  Created by 김동우 on 2022/08/06.
//

import Foundation

import RxSwift
import RxRelay

protocol FetchGraphDataUseCase {
    var yearMonthDayDataSubject: PublishSubject<GraphDomainModel> { get }
    var yearMonthDayDataRelay: BehaviorRelay<[[String : Any]]> { get }
    func createGraphThisYearMonthDayData()
    func uploadDangAverage(_ data: Int)
}
